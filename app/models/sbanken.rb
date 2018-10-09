require 'net/https'
class Sbanken < Source
  jsonb_accessor :properties,
                 nin: :string,
                 client_id: :string,
                 secret: :string

  validates :nin, presence: true
  validates :client_id, presence: true
  validates :secret, presence: true

  def sync
    sbanken_accounts = accounts
    synced_account_ids = []
    created = 0
    updated = 0
    deleted = 0

    sbanken_accounts.each do |sbanken_account|
      existing_account = SbankenAccount.where(source_id: self.id, ext_id: sbanken_account['accountId']).first
      if existing_account.nil?
        created += 1
        new_account = SbankenAccount.new
        new_account.source = self
        new_account.ext_id = sbanken_account['accountId']
        new_account.name = sbanken_account['name']
        new_account.properties = sbanken_account.to_json
        new_account.save!
        synced_account_ids << new_account.id
      else
        updated += 1
        synced_account_ids << existing_account.id
        existing_account.name = sbanken_account['name']
        existing_account.properties = sbanken_account.to_json
        existing_account.save!
      end
    end

    self.collections.each do |sbanken_account|
      unless synced_account_ids.include?(sbanken_account.id)
        updated += 1
        sbanken_account.destroy!
      end
    end
    {created: created, updated: updated, deleted: deleted}
  end

  protected

  def accounts
    Rails.cache.fetch(['accounts', Sbanken.name, self.id], expires_in: 10.minutes) do
      http_get('https://api.sbanken.no/bank/api/v1/Accounts')['items']
    end
  end

  def access_token
    Rails.cache.fetch(['access_token', Sbanken.name, self.id], expires_in: 3000.seconds) do
      url = URI.parse('https://auth.sbanken.no/identityserver/connect/token')
      http = Net::HTTP.new(url.host, url.port)
      req = Net::HTTP::Post.new(url.path, initheader = {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Accept' => 'application/json',
      })
      http.use_ssl = true
      req.basic_auth self.client_id, self.secret
      req.body = "grant_type=client_credentials"
      response = http.request(req)
      JSON.parse(response.body)['access_token']
    end
  end

  private

  def http_get(url)
    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.get(url.path, {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{self.access_token}",
        'customerId' => self.nin
    })
    JSON.parse(response.body)
  end


end
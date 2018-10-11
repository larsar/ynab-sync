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
    access_token = SbankenAPI.access_token(self.client_id, self.secret, self.id)
    accounts_json = SbankenAPI.accounts(access_token, self.id, self.nin)
    synced_account_ids = []
    created = 0
    updated = 0
    deleted = 0

    accounts_json.each do |account_json|
      existing_account = SbankenAccount.where(source_id: self.id, ext_id: account_json['accountId']).first
      if existing_account.nil?
        created += 1
        new_account = SbankenAccount.new
        new_account.source = self
        new_account.ext_id = account_json['accountId']
        new_account.name = account_json['name']
        new_account.properties = account_json.to_json
        new_account.save!
        synced_account_ids << new_account.id
      else
        updated += 1
        synced_account_ids << existing_account.id
        existing_account.name = account_json['name']
        existing_account.properties = account_json.to_json
        existing_account.save!
      end
    end

    self.reload
    self.collections.each do |account|
      if synced_account_ids.include?(account.id)
        updated += 1
        if Account.where(collection_id: account.id).count > 0
          account.sync_transactions
        end
      else
        deleted += 1
        account.destroy!
      end
    end
    { created: created, updated: updated, deleted: deleted }
  end

end
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

    accounts_json.each do |account_json|
      account = SbankenAccount.upsert(account_json, self)
      synced_account_ids << account.id
    end

    self.reload
    self.collections.each do |collection|
      if synced_account_ids.include?(collection.id)
        if Account.where(collection_id: collection.id).count > 0
          collection.sync_transactions
        end
      else
        collection.destroy!
      end
    end
  end

end
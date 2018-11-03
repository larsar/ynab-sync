class SbankenAccount < Collection

  def sync_transactions
    access_token = SbankenAPI.access_token(self.source.client_id, self.source.secret, self.source.id)
    transactions_json = SbankenAPI.transactions(self.ext_id, access_token, self.source.id, self.source.nin)
    synced_transaction_ids = []

    transactions_json.each do |transaction_hash|
      next if transaction_hash['transactionId'] == '0'
      transaction = SbankenTransaction.upsert(transaction_hash, self)
      synced_transaction_ids << transaction.id
    end

    self.reload
    self.items.each do |item|
      if synced_transaction_ids.include?(item.id)
        self.accounts.each do |account|
          if account.auto_sync && account.transactions.where(item_id: item.id).count == 0
            begin
              Transaction.import_from_item(item, account)
            rescue RuntimeError => e
              puts "Failed to import #{item.memo}"
            end
          end
        end
      else
        item.destroy!
      end
    end
  end

  def self.upsert(account_hash, source)
    account = SbankenAccount.where(source_id: source.id, ext_id: account_hash['accountId']).first
    if account.nil?
      account = SbankenAccount.new
      account.source = source
    end
    account.name = account_hash['name']
    account.ext_id = account_hash['accountId']
    account.name = account_hash['name']
    account.properties = account_hash.to_json
    account.save!

    account
  end


end
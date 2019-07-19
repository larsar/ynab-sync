class SbankenAccount < Collection

  def sync_transactions
    access_token = SbankenAPI.get_access_token(self.source.client_id, self.source.secret, self.source.id)
    transactions_json = SbankenAPI.get_transactions(self.ext_id, access_token, self.source.id, self.source.nin)
    synced_transaction_ids = []

    transactions_json.each do |transaction_hash|
      next if transaction_hash['isReservation']
      transaction = SbankenTransaction.upsert(transaction_hash, self)
      synced_transaction_ids << transaction.id
    end

    self.reload
    self.items.each do |item|
      if synced_transaction_ids.include?(item.id)
        self.accounts.each do |account|
          if account.transactions.where(item_id: item.id).count == 0
            prev_imported_transaction = account.transactions.where(import_id: item.ext_id).first
            if !prev_imported_transaction.nil?
              prev_imported_transaction.item = item
              prev_imported_transaction.save!
            elsif account.auto_sync
              begin
                Transaction.import_from_item(item, account)
              rescue RuntimeError => e
                puts "Failed to import #{item.memo}"
              end
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
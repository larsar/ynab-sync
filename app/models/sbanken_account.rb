class SbankenAccount < Collection

  def sync
    access_token = SbankenAPI.access_token(self.source.client_id, self.source.secret, self.source.id)
    transactions_json = SbankenAPI.transactions(self.ext_id, access_token, self.id, self.source.nin)

    puts transactions_json
  end

  def sync_transactions
    access_token = SbankenAPI.access_token(self.source.client_id, self.source.secret, self.source.id)
    transactions_json = SbankenAPI.transactions(self.ext_id, access_token, self.source.id, self.source.nin)
    synced_transaction_ids = []
    created = 0
    updated = 0
    deleted = 0

    transactions_json.each do |transaction_json|
      next if transaction_json['transactionId'] == '0'
      transaction = SbankenTransaction.where(collection_id: self.id, ext_id: transaction_json['transactionId']).first
      if transaction.nil?
        created += 1
        transaction = SbankenTransaction.new
        transaction.collection = self
        transaction.amount = transaction_json['amount']
        transaction.ext_id = transaction_json['transactionId']
      else
        updated += 1
      end
      transaction.amount = transaction_json['amount']
      transaction.date = transaction_json['accountingDate']
      transaction.memo = transaction_json['text']

      transaction.save!
      synced_transaction_ids << transaction.id
    end

    self.reload
    self.items.each do |item|
      if synced_transaction_ids.include?(item.id)
        updated += 1
      else
        deleted += 1
        item.destroy!
      end
    end
    { created: created, updated: updated, deleted: deleted }
  end


end
class SbankenTransaction < Item
  jsonb_accessor :properties,
                 memo: :string

  def self.upsert(transaction_hash, collection)
    transaction = SbankenTransaction.where(collection_id: collection.id, ext_id: transaction_hash['transactionId']).first
    if transaction.nil?
      transaction = SbankenTransaction.new
      transaction.collection = collection
    end
    transaction.amount = transaction_hash['amount']
    transaction.ext_id = transaction_hash['transactionId']
    transaction.date = transaction_hash['accountingDate']
    transaction.memo = transaction_hash['text']
    transaction.save!

    transaction
  end

end
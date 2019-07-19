class SbankenTransaction < Item
  jsonb_accessor :properties,
                 memo: :string

  def self.upsert(transaction_hash, collection)
    ext_id = Digest::MD5.hexdigest "#{transaction_hash['accountingDate']}#{transaction_hash['interestDate']}#{transaction_hash['amount']}#{transaction_hash['text']}#{transaction_hash['transactionType']}#{transaction_hash['transactionTypeCode']}"
    transaction = SbankenTransaction.where(collection_id: collection.id, ext_id: ext_id).first
    if transaction.nil?
      transaction = SbankenTransaction.new
      transaction.collection = collection
    end
    transaction.amount = transaction_hash['amount']
    transaction.ext_id = ext_id
    transaction.date = transaction_hash['accountingDate']
    transaction.memo = transaction_hash['text']
    transaction.save!

    transaction
  end

end
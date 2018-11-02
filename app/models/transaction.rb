class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :item, optional: true

  jsonb_accessor :properties,
                 memo: :string

  CLEARED = 'cleared'
  UNCLEARED = 'uncleared'
  RECONCILED = 'reconciled'

  def clear
    transaction_hash = YnabAPI.update_transaction(self.account.budget.user_id, self.account.budget_id, self.ext_id, { cleared: 'cleared' }, self.account.budget.user.ynab_access_token)
    self.state = transaction_hash['cleared']
    self.save!
  end

  def unclear
    transaction_hash = YnabAPI.update_transaction(self.account.budget.user_id, self.account.budget_id, self.ext_id, { cleared: 'uncleared' }, self.account.budget.user.ynab_access_token)
    self.state = transaction_hash['cleared']
    self.save!
  end

  def create_ynab_transaction
    data = {
        account_id: self.account_id,
        date: "#{self.date.strftime("%Y-%m-%d")}",
        amount: (self.amount * 1000).to_i,
        memo: self.memo,
        cleared: self.state
    }
    unless self.item.nil?
      data[:import_id] = self.item.ext_id
    end

    transaction_hash = YnabAPI.create_transaction(self.account.budget.user_id, self.account.budget_id, data, self.account.budget.user.ynab_access_token)
    update_from_hash(transaction_hash)
  end

  def update_from_hash(transaction_hash)
    self.ext_id = transaction_hash['id']
    self.memo = transaction_hash['memo']
    self.amount = transaction_hash['amount'] / 1000.0
    self.date = transaction_hash['date'].to_date
    self.state = transaction_hash['cleared']
    self.memo = transaction_hash['memo']
    self.save!
  end

  def self.upsert(transaction_hash, account)
    transaction = Transaction.find_by_ext_id(transaction_hash['id'])

    if transaction.nil?
      transaction = Transaction.new
      transaction.ext_id = transaction_hash['id']
      puts "Creating new transaction: account=#{self.name} amount=#{transaction_hash['amount'] / 1000} id=#{transaction.id} json_id=#{transaction_hash['id']}"
    else
      puts "Updating transaction: account=#{transaction.account.name} amount=#{transaction.amount} id=#{transaction.id} json_id=#{transaction_hash['id']}"
    end
    transaction.account = account
    transaction.update_from_hash(transaction_hash)
    transaction
  end

end

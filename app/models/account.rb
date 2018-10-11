class Account < ApplicationRecord
  belongs_to :budget
  belongs_to :collection, optional: true
  has_many :transactions
  has_many :items, through: :transactions

  def sync_transactions
    transactions_json = YnabAPI.transactions(budget.user_id, budget.id, self.id, budget.user.ynab_access_token)
    synced_transaction_ids = []

    transactions_json.each do |transaction_json|
      transaction = Transaction.find_by_ext_id(transaction_json['id'])

      if transaction.nil?
        transaction = Transaction.new
        transaction.ext_id = transaction_json['id']
        puts "Creating new transaction: account=#{self.name} amount=#{transaction_json['amount']/1000} id=#{transaction.id} json_id=#{transaction_json['id']}"
      else
        puts "Updating transaction: account=#{transaction.account.name} amount=#{transaction.amount} id=#{transaction.id} json_id=#{transaction_json['id']}"
      end
      transaction.account = self
      transaction.amount = transaction_json['amount']/1000.0
      transaction.date = transaction_json['date'].to_date
      transaction.approved = transaction_json['approved']
      transaction.state = transaction_json['cleared']
      transaction.properties = transaction_json
      transaction.save!
      synced_transaction_ids << transaction.id
    end

    self.reload
    self.transactions.each do |transaction|
      unless synced_transaction_ids.include?(transaction.id)
        puts "Deleting transaction: account=#{transaction.account.name} amount=#{transaction.amount} id=#{transaction.id}"
        transaction.destroy!
      end
    end
  end


  def self.sync(user, budget)
    accounts_json = YnabAPI.accounts(user.id, budget.id, user.ynab_access_token)
    synced_account_ids = []

    accounts_json.each do |account_json|
      if account_json['deleted'] || account_json['closed']
        next
      end
      account = Account.where(id: account_json['id']).first

      if account.nil?
        account = budget.accounts.build
        account.id = account_json['id']
      end
      account.name = account_json['name']
      account.properties = account_json.to_json
      account.save!
      synced_account_ids << account.id
    end

    budget.accounts.each do |account|
      if synced_account_ids.include?(account.id)
        if account.collection_id.nil?
          Transaction.where(account_id: account.id).delete_all
          account.transactions.delete_all
        else
          account.sync_transactions
        end
      else
        account.destroy!
      end
    end
  end

end

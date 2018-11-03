class Account < ApplicationRecord
  belongs_to :budget
  belongs_to :collection, optional: true
  has_many :transactions
  has_many :items, through: :transactions

  def sync_transactions
    transactions_json = YnabAPI.transactions(budget.user_id, budget.id, self.id, budget.user.ynab_access_token)
    synced_transaction_ids = []

    transactions_json.each do |transaction_hash|
      transaction = Transaction.upsert(transaction_hash, self)
      synced_transaction_ids << transaction.id
    end

    self.reload
    self.transactions.each do |transaction|
      unless synced_transaction_ids.include?(transaction.id)
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

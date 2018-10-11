class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :item, optional: true
  CLEARED = 'cleared'
  UNCLEARED = 'uncleared'
  RECONCILED = 'reconciled'

  def clear
    transaction_json = YnabAPI.update_transaction(self.account.budget.user_id, self.account.budget_id, self.ext_id, { cleared: 'cleared' }, self.account.budget.user.ynab_access_token)
    self.state = transaction_json['cleared']
    self.save!
  end

  def unclear
    transaction_json = YnabAPI.update_transaction(self.account.budget.user_id, self.account.budget_id, self.ext_id, { cleared: 'uncleared' }, self.account.budget.user.ynab_access_token)
    self.state = transaction_json['cleared']
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

    transaction_data = YnabAPI.create_transaction(self.account.budget.user_id, self.account.budget_id, data, self.account.budget.user.ynab_access_token)
    update_from_response(transaction_data)
  end

  def update_from_response(response)
    self.ext_id = response['id']
    self.properties = response
    self.save!
  end

end

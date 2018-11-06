require 'net/http'

class Budget < ApplicationRecord
  belongs_to :user
  has_many :accounts, dependent: :destroy
  has_many :transactions, through: :accounts

  def self.sync(user)
    budgets_json = YnabAPI.get_budgets(user.id, user.ynab_access_token)
    synced_budget_ids = []

    budgets_json.each do |budget_json|
      budget = Budget.where(id: budget_json['id'], user_id: user.id).first
      if budget.nil?
        budget = user.budgets.build
        budget.id = budget_json['id']
      end
      budget.name = budget_json['name']
      budget.properties = budget_json.to_json
      budget.save!
      synced_budget_ids << budget.id
    end

    user.reload
    user.budgets.each do |budget|
      unless synced_budget_ids.include?(budget.id)
        budget.destroy!
      else
        if budget.enabled
          Account.sync(user, budget)
        else
          budget.accounts.each do |account|
            account.destroy!
          end
        end
      end
    end
  end
  
end

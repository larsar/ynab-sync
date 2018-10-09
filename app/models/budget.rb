require 'net/http'

class Budget < ApplicationRecord
  belongs_to :user
  has_many :accounts, dependent: :destroy

  def self.sync(user)
    ynab_budgets_json = YnabAPI.budgets(user.ynab_access_token)
    synced_budget_ids = []

    ynab_budgets_json.each do |budget|
      existing_budget = Budget.where(id: budget['id'], user_id: user.id).first

      if existing_budget.nil?
        new_budget = user.budgets.build
        new_budget.id = budget['id']
        new_budget.name = budget['name']
        new_budget.save!
        synced_budget_ids << new_budget.id
      else
        synced_budget_ids << existing_budget.id
        if existing_budget.name != budget['name']
          existing_budget = budget['name']
          existing_budget.save!
        end
      end
    end

    user.budgets.each do |budget|
      unless synced_budget_ids.include?(budget.id)
        budget.destroy!
      else
        Account.sync(user, budget)
      end
    end
  end
  
end

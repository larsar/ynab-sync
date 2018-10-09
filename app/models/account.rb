class Account < ApplicationRecord
  belongs_to :budget
  belongs_to :collection, optional: true

  def self.sync(user, budget)
    ynab_accounts_json = YnabAPI.accounts(budget.id, user.ynab_access_token)
    synced_ynab_account_ids = []

    ynab_accounts_json.each do |ynab_account|
      if ynab_account['deleted'] || ynab_account['closed']
        next
      end
      existing_ynab_account = Account.where(id: ynab_account['id']).first

      if existing_ynab_account.nil?
        new_ynab_account = budget.accounts.build
        new_ynab_account.id = ynab_account['id']
        new_ynab_account.name = ynab_account['name']
        new_ynab_account.properties = ynab_account.to_json
        new_ynab_account.save!
        synced_ynab_account_ids << new_ynab_account.id
      else
        synced_ynab_account_ids << existing_ynab_account.id
        existing_ynab_account.name = ynab_account['name']
        existing_ynab_account.properties = ynab_account.to_json
        existing_ynab_account.save!
      end
    end

    budget.accounts.each do |ynab_accounts|
      unless synced_ynab_account_ids.include?(ynab_accounts.id)
        ynab_accounts.destroy!
      end
    end
  end

end

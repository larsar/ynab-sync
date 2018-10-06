class YnabAccount < ApplicationRecord
  belongs_to :user
  belongs_to :budget

  def self.sync(user, budget)
    url = URI.parse("https://api.youneedabudget.com/v1/budgets/#{budget.id}/accounts")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.get(url.path, {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{user.ynab_access_token}"
    })
    data = response.body

    synced_ynab_account_ids = []

    JSON.parse(data)['data']['accounts'].each do |ynab_account|
      puts ynab_account
      if ynab_account['deleted'] || ynab_account['closed']
        puts "Ignoring account for #{budget.name}: #{ynab_account}"
        next
      end
      puts "Syncing account for #{budget.name}: #{ynab_account}"
      existing_ynab_account = YnabAccount.where(id: ynab_account['id'], user_id: user.id).first

      if existing_ynab_account.nil?
        new_ynab_account = budget.ynab_accounts.build
        new_ynab_account.user_id = user.id
        new_ynab_account.id = ynab_account['id']
        new_ynab_account.name = ynab_account['name']
        new_ynab_account.save!
        synced_ynab_account_ids << new_ynab_account.id
      else
        synced_ynab_account_ids << existing_ynab_account.id
        if existing_ynab_account.name != ynab_account['name']
          existing_ynab_account = ynab_account['name']
          existing_ynab_account.save!
        end
      end
    end

    budget.ynab_accounts.each do |ynab_accounts|
      unless synced_ynab_account_ids.include?(ynab_accounts.id)
        ynab_accounts.destroy!
      end
    end
  end

end

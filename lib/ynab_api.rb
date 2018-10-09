class YnabAPI
  def self.accounts(budget_id, access_token)
    Rails.cache.fetch(['accounts', 'YNAB', budget_id], expires_in: 10.minutes) do
      http_get("https://api.youneedabudget.com/v1/budgets/#{budget_id}/accounts", access_token)['data']['accounts']
    end
  end

  def self.budgets(access_token)
    Rails.cache.fetch(['budgets', access_token], expires_in: 10.minutes) do
      http_get('https://api.youneedabudget.com/v1/budgets', access_token)['data']['budgets']
    end
  end

  def self.http_get(url, access_token)
    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.get(url.path, {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{access_token}"
    })
    JSON.parse(response.body)
  end

end
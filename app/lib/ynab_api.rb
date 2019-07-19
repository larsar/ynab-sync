class YnabAPI
  def self.get_accounts(user_id, budget_id, access_token)
    Rails.cache.fetch(['accounts', 'YNAB', budget_id], expires_in: 1.second) do
      url = "https://api.youneedabudget.com/v1/budgets/#{budget_id}/accounts"
      response = send_api_call(url, :get, nil, user_id, access_token)
      JSON.parse(response.body)['data']['accounts']
    end
  end

  def self.get_budgets(user_id, access_token)
    Rails.cache.fetch(['budgets', user_id], expires_in: 1.second) do
      url = 'https://api.youneedabudget.com/v1/budgets'
      response = send_api_call(url, :get, nil, user_id, access_token)
      JSON.parse(response.body)['data']['budgets']
    end
  end

  def self.get_transactions(user_id, budget_id, account_id, access_token)
    url = "https://api.youneedabudget.com/v1/budgets/#{budget_id}/accounts/#{account_id}/transactions?since_date=#{(Time.now - 3.weeks).strftime("%Y-%m-%d")}"
    response = send_api_call(url, :get, nil, user_id, access_token)
    JSON.parse(response.body)['data']['transactions']
  end

  def self.create_transaction(user_id, budget_id, data, access_token)
    url = "https://api.youneedabudget.com/v1/budgets/#{budget_id}/transactions"
    response = send_api_call(url, :post, { transaction: data }, user_id, access_token)
    if response.code == '409'
      raise 'Transaction is already imported in YNAB'
    else
      JSON.parse(response.body)['data']['transaction']
    end
  end

  def self.update_transaction(user_id, budget_id, transaction_id, data, access_token)
    url = "https://api.youneedabudget.com/v1/budgets/#{budget_id}/transactions/#{transaction_id}"
    response = send_api_call(url, :put, { transaction: data }, user_id, access_token)
    JSON.parse(response.body)['data']['transaction']
  end

  def self.send_api_call(url, method, data, user_id, access_token)
    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    path = url.path
    path = "#{path}?#{url.query}" if url.query
    headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{access_token}"
    }

    case method
    when :get
      response = http.get(path, headers)
    when :put
      response = http.put(path, data.to_json, headers)
    when :post
      response = http.post(path, data.to_json, headers)
    end
    api_rate_limit_token = Cache.token(Cache::API_RATE_LIMIT_YNAB_TOKEN, user_id, 60.minutes)
    Rails.cache.increment([Cache::API_RATE_LIMIT_YNAB, user_id, api_rate_limit_token])
    response
  end

end
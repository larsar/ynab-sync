class YnabAPI
  def self.accounts(user_id, budget_id, access_token)
    Rails.cache.fetch(['accounts', 'YNAB', budget_id], expires_in: 10.minutes) do
      url = "https://api.youneedabudget.com/v1/budgets/#{budget_id}/accounts"
      send_api_call(url, :get, nil, user_id, access_token)['data']['accounts']
    end
  end

  def self.budgets(user_id, access_token)
    Rails.cache.fetch(['budgets', user_id], expires_in: 10.minutes) do
      url = 'https://api.youneedabudget.com/v1/budgets'
      send_api_call(url, :get, nil, user_id, access_token)['data']['budgets']
    end
  end

  def self.transactions(user_id, budget_id, account_id, access_token)
    #Rails.cache.fetch(['transactions', budget_id, account_id], expires_in: 10.minutes) do
      url = "https://api.youneedabudget.com/v1/budgets/#{budget_id}/accounts/#{account_id}/transactions?since_date=#{(Time.now - 50.days).strftime("%Y-%m-%d")}"
      send_api_call(url, :get, nil, user_id, access_token)['data']['transactions']
    #end
  end

  def self.create_transaction(user_id, budget_id, data, access_token)
    url = "https://api.youneedabudget.com/v1/budgets/#{budget_id}/transactions"
    send_api_call(url, :post, {transaction: data}, user_id, access_token)['data']['transaction']
  end

  def self.update_transaction(user_id, budget_id, transaction_id, data, access_token)
    url = "https://api.youneedabudget.com/v1/budgets/#{budget_id}/transactions/#{transaction_id}"
    send_api_call(url, :put, {transaction: data}, user_id, access_token)['data']['transaction']
  end

  def self.send_api_call(url, method, data, user_id, access_token)
    api_rate_limit_token = Cache.token(Cache::API_RATE_LIMIT_YNAB_TOKEN, user_id, 60.minutes)

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

    Rails.cache.write([Cache::API_RATE_LIMIT_YNAB, user_id, api_rate_limit_token], response.header['x-rate-limit'], expires_in: 60.minutes)

    JSON.parse(response.body)
  end

end
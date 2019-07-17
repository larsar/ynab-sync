class SbankenAPI
  def self.get_accounts(access_token, source_id, nin)
    Rails.cache.fetch(['accounts', Sbanken.name, source_id], expires_in: 1.minute) do
      SbankenAPI.http_get('https://api.sbanken.no/exec.bank/api/v1/Accounts', access_token, nin)['items']
    end
  end

  def self.get_transactions(ext_account_id, access_token, source_id, nin)
    Rails.cache.fetch(['transaction', Sbanken.name, ext_account_id, source_id], expires_in: 1.minute) do
      SbankenAPI.http_get("https://api.sbanken.no/exec.bank/api/v1/Transactions/#{ext_account_id}?startDate=#{(Time.now - 2.weeks).strftime("%Y-%m-%d")}", access_token, nin)['items']
    end
  end

  def self.get_access_token(client_id, client_secret, source_id)
    Rails.cache.fetch(['access_token', Sbanken.name, source_id], expires_in: 900.seconds) do
      url = URI.parse('https://auth.sbanken.no/identityserver/connect/token')
      http = Net::HTTP.new(url.host, url.port)
      req = Net::HTTP::Post.new(url.path, initheader = {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Accept' => 'application/json',
      })
      http.use_ssl = true
      req.basic_auth client_id, client_secret
      req.body = "grant_type=client_credentials"
      response = http.request(req)
      JSON.parse(response.body)['access_token']
    end
  end

  def self.http_get(url, access_token, nin)
    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    path = url.path
    path = "#{path}?#{url.query}" if url.query
    response = http.get(path, {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{access_token}",
        'customerId' => nin

    })

    JSON.parse(response.body)
  end

end
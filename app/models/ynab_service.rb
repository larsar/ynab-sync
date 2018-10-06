require 'net/http'

class YnabService < Service
  TYPE = 'YnabService'
  jsonb_accessor :config,
                 api_key: :string

  validates :name, presence: true
  validates :api_key, presence: true

  def type_display
    'YNAB'
  end

  def ping
    url = URI.parse('https://api.youneedabudget.com/v1/user')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.get(url.path, {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{self.api_key}"
    })
    puts response.header
    puts response.body
  end

end
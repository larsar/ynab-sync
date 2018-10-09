class Sbanken < Service
  jsonb_accessor :config,
                 nin: :string,
                 client_id: :string,
                 secret: :string

  validates :nin, presence: true
  validates :client_id, presence: true
  validates :secret, presence: true

end
class Service < ApplicationRecord
  belongs_to :user
  SBANKEN = Sbanken.name
end

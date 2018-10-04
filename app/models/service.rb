class Service < ApplicationRecord
  belongs_to :user
  TYPE_YNAB = 'ynab'
end

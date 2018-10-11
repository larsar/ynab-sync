class Item < ApplicationRecord
  belongs_to :collection
  has_many :transactions, dependent: :nullify
end

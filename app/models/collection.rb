class Collection < ApplicationRecord
  belongs_to :source
  has_many :items, dependent: :destroy
  has_many :accounts, dependent: :nullify

  def display_name
    "#{source.name} - #{name}"
  end
end

class Collection < ApplicationRecord
  belongs_to :source
  has_many :items, dependent: :destroy

  def display_name
    "#{source.name} - #{name}"
  end
end

class Source < ApplicationRecord
  belongs_to :user
  has_many :collections, dependent: :destroy

  SBANKEN = Sbanken.name

  def sync
    raise 'Only on sub class'
  end
end

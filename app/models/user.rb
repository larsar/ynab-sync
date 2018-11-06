class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :sources, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :collections, through: :sources
  has_many :items, through: :collections
  has_many :accounts, through: :budgets
  has_many :transactions, through: :accounts

  def sync
    Budget.sync_budget(self)
    self.sources.each do |source|
      source.sync_source
    end
    self.last_synced_at = Time.now
    self.save!
  end

end

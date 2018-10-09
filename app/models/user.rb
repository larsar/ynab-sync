class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :sources, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :collections, through: :sources
  has_many :accounts, through: :budgets

end

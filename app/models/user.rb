class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :services, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :ynab_accounts

end

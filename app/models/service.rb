class Service < ApplicationRecord
  belongs_to :user
  TYPE_YNAB = 'ynab'
  def type_display
    raise 'Not implemented'
  end
end

class SyncController < ApplicationController
  respond_to :html


  def sync_budgets
    Budget.sync(current_user)
  end

end
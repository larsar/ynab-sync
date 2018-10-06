class BudgetsController < ApplicationController
  respond_to :html
  def index
    @budgets = current_user.budgets
  end

  def sync
    Budget.sync(current_user)
    redirect_to budgets_path
  end

end

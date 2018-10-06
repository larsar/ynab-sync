class YnabAccountsController < ApplicationController
  respond_to :html
  def index
    @ynab_accounts = current_user.ynab_accounts
  end

  def sync
    Budget.sync(current_user)
    redirect_to budgets_path
  end
end
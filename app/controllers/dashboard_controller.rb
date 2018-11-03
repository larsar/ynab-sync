class DashboardController < ApplicationController
  respond_to :html

  def index
    if current_user.ynab_access_token.blank?
      flash[:error] = 'YNAB personal access token is not set'
    end
  end


  def sync
    current_user.sync
    flash[:notice] = 'Sync completed'
    redirect_to root_path
  end

end

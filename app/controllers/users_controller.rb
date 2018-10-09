class UsersController < ApplicationController
  respond_to :html

  def edit_ynab_access_token
    @user = current_user
  end

  def update_access_token
    current_user.ynab_access_token = params[:user].permit(:ynab_access_token)[:ynab_access_token]
    current_user.save!
    
    redirect_to setup_path
  end

end

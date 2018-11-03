class UsersController < ApplicationController
  respond_to :html

  def breadcrumbs
    add_crumb 'Setup', setup_path
  end

  def   edit_ynab_access_token
    @user = current_user
  end

  def update_access_token
    current_user.ynab_access_token = params[:user][:ynab_access_token]
    current_user.save!
    
    redirect_to setup_path
  end

end

class AccountsController < ApplicationController
  respond_to :html

  def index
    @accounts = current_user.accounts
  end

  def edit
    @account = current_user.accounts.where(id: params[:id]).first
    @collections = current_user.collections.where.not(id: current_user.accounts.where('collection_id is not null').pluck(:collection_id))
    render_not_found if @account.nil?
  end

  def update
    @account = current_user.accounts.where(id: params[:id]).first
    @collection = current_user.collections.where(id: params[:account][:collection_id]).where.not(id: current_user.accounts.where('collection_id is null').pluck(:id)).first
    render_not_found and return if @account.nil?
    render_forbidden and return if @collection.nil?

    @account.collection = @collection
    @account.save!
    redirect_to accounts_path
  end

  def unlink
    @account = current_user.accounts.where(id: params[:account_id]).first
    render_not_found and return if @account.nil?
    @account.collection = nil
    @account.save!
    redirect_to accounts_path
  end

  def sync
    Budget.sync(current_user)
    redirect_to budgets_path
  end
end
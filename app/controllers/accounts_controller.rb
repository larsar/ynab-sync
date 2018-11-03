class AccountsController < ApplicationController
  respond_to :html
  before_action :prepare

  def prepare
    if params[:budget_id]
      @budget = current_user.budgets.where(id: params[:budget_id]).first
      add_crumb 'Budgets', budgets_path
      add_crumb @budget.name, budget_path(@budget)
      add_crumb 'Accounts', budget_accounts_path(@budget)
    end
    account_id = params[:account_id] ||= params[:id]
    if account_id
      @account = current_user.accounts.where(id: account_id).first
    end
  end

  def index
    if @budget
      @accounts = Account.joins(:budget).where("budgets.user_id = '%s' AND budget_id = '%s'", current_user.id, @budget.id).order('budgets.name ASC')
    else
      @accounts = Account.joins(:budget).where("budgets.user_id = '%s'", current_user.id).order('budgets.name ASC')
    end
  end

  def edit
    @collections = current_user.collections.where.not(id: current_user.accounts.where('collection_id is not null').where(budget_id: @budget.id).pluck(:collection_id))
    render_not_found if @account.nil?
  end

  def show
    add_crumb @account.name, budget_account_path(@budget, @account)
    @transactions = Transaction.where(account_id: @account.id).order('date DESC')
    unless @account.collection_id.blank?
      @items = Item.joins(:collection).where("collections.id = '%s'", @account.collection_id).order('date DESC')
    else
      @items = []
    end
  end

  def update
    @collection = current_user.collections.where(id: params[:account][:collection_id]).where.not(id: current_user.accounts.where('collection_id is null').pluck(:id)).first
    render_not_found and return if @account.nil?
    render_forbidden and return if @collection.nil?

    @account.collection = @collection
    @account.save!
    redirect_to budget_accounts_path(@budget)
  end

  def unlink
    render_not_found and return if @account.nil?
    @account.collection = nil
    @account.save!
    redirect_to budget_accounts_path(@budget)
  end

  def auto_sync
    render_not_found and return if @account.nil?
    @account.auto_sync = true
    @account.save!
    redirect_to budget_account_path(@budget, @account)
  end

  def manual_sync
    render_not_found and return if @account.nil?
    @account.auto_sync = false
    @account.save!
    redirect_to budget_account_path(@budget, @account)
  end

  def sync
    Budget.sync(current_user)
    redirect_to budgets_path
  end
end
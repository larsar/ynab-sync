class BudgetsController < ApplicationController
  respond_to :html

  def breadcrumbs
    add_crumb 'Budgets', budgets_path
  end

  def index
    @budgets = current_user.budgets
  end

  def show
    @budget = Budget.where("id = '%s' AND user_id = '%s'", params[:id], current_user.id).first
    add_crumb @budget.name, budget_path(@budget)
  end

  def enable
    @budget = Budget.where(user_id: current_user.id, id: params[:budget_id]).first
    @budget.enabled = true
    @budget.save!
    respond_with @budget
  end

  def disable
    @budget = Budget.where(user_id: current_user.id, id: params[:budget_id]).first
    @budget.enabled = false
    @budget.save!
    redirect_to @budget
  end

  def sync
    Budget.sync(current_user)
    redirect_to budgets_path
  end


end

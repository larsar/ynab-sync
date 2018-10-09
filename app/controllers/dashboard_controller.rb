class DashboardController < ApplicationController
  respond_to :html

  def index
    if current_user.ynab_access_token.blank?
      flash[:error] = 'YNAB personal access token is not set'
    end
  end


  def sync_budgets
    Budget.sync(current_user)
    redirect_to root_path
  end

  def sync_banks
    num_sources = num_acc_created = num_acc_updated = num_acc_deleted = 0

    current_user.sources.each do |source|
      stats = source.sync
      num_sources += 1
      num_acc_created += stats[:created]
      num_acc_updated += stats[:updated]
      num_acc_deleted += stats[:deleted]
    end

    flash[:notice] = "Synced #{num_sources} sources, Accounts created=#{num_acc_created} updated=#{num_acc_updated} deleted=#{num_acc_deleted}"

    redirect_to root_path
  end

end

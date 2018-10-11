class TransactionsController < ApplicationController
  respond_to :html

  def clear
    @transaction = current_user.transactions.where(id: params[:transaction_id]).first
    @transaction.clear
    redirect_back(fallback_location: root_path)
  end

  def unclear
    @transaction = current_user.transactions.where(id: params[:transaction_id]).first
    @transaction.unclear
    redirect_back(fallback_location: root_path)
  end

  def import
    item = current_user.items.where(id: params[:item_id]).first
    account = current_user.accounts.where(collection_id: item.collection_id).first

    t = Transaction.new
    t.account = account
    t.item = item
    t.amount = item.amount
    t.date = item.date
    t.memo = item.memo
    t.state = Transaction::CLEARED
    t.save!
    t.create_ynab_transaction

    redirect_back(fallback_location: root_path)
  end

end
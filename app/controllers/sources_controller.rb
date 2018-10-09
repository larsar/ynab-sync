class SourcesController < ApplicationController
  respond_to :html

  def index
    @sources = current_user.sources
  end

  def new
    case params[:type]
    when Source::SBANKEN
      @source = Sbanken.new
      @source.name = 'My Sbanken'
    else
      raise 'Invalid type'
    end
  end

  def create
    case params[:sbanken][:type]
    when Source::SBANKEN
      par = params[:sbanken].permit(:name, :nin, :client_id, :secret)
      @source = Sbanken.new(par)
    else
      raise 'Invalid type'
    end
    @source.user = current_user
    @source.save! if @source.valid?
    respond_with @source, location: -> { sources_path }
  end

  def edit
    @source = Source.where(id: params[:id], user_id: current_user.id).first
    respond_with @source
  end

  def update
    @source =  Source.where(id: params[:id], user_id: current_user.id).first

    case @source
    when YnabService
      par = params[:ynab_service].permit(:name, :api_key)
      @source.update_attributes(par)
      @source.save! if @source.valid?
    else
      raise 'Invalid type'
    end
    
    respond_with @source, location: -> { sources_path }
  end

  def destroy
    @source =  Source.where(id: params[:id], user_id: current_user.id).first
    @source.destroy!

    redirect_to sources_path
  end

end

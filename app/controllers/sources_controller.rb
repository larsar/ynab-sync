class SourcesController < ApplicationController
  respond_to :html

  def breadcrumbs
    add_crumb 'Bank sources', sources_path
  end

  def index
    @sources = current_user.sources
  end

  def new
    case params[:type]
    when Sbanken.name
      @source = Sbanken.new
      @source.name = 'My Sbanken'
    else
      raise 'Invalid type'
    end
  end

  def show
    @source = Source.where("user_id = '%s' AND id = '%s'", current_user.id, params[:id]).first
    add_crumb @source.name, source_path(@source)
  end

  def create
    case params[:sbanken][:type]
    when Sbanken.name
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
    when Sbanken
      par = params[:sbanken].permit(:name, :nin, :client_id, :secret)
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

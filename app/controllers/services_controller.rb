class ServicesController < ApplicationController
  respond_to :html

  def index
    @services = current_user.services
  end

  def new
    case params[:type]
    when Service::SBANKEN
      @service = Sbanken.new
      @service.name = 'My Sbanken'
    else
      raise 'Invalid type'
    end
  end

  def create
    case params[:sbanken][:type]
    when Service::SBANKEN
      par = params[:sbanken].permit(:name, :nin, :client_id, :secret)
      @service = Sbanken.new(par)
    else
      raise 'Invalid type'
    end
    @service.user = current_user
    @service.save! if @service.valid?
    respond_with @service, location: -> { services_path }
  end

  def edit
    @service = Service.where(id: params[:id], user_id: current_user.id).first
    respond_with @service
  end

  def update
    @service =  Service.where(id: params[:id], user_id: current_user.id).first

    case @service
    when YnabService
      par = params[:ynab_service].permit(:name, :api_key)
      @service.update_attributes(par)
      @service.save! if @service.valid?
    else
      raise 'Invalid type'
    end
    
    respond_with @service, location: -> { services_path }
  end

  def destroy
    @service =  Service.where(id: params[:id], user_id: current_user.id).first
    @service.destroy!

    redirect_to services_path
  end

end

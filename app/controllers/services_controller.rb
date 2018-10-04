class ServicesController < ApplicationController
  respond_to :html

  def index
    @services = current_user.services
  end

  def new
    case params[:type]
    when Service::TYPE_YNAB
      @service = YnabService.new
      @service.name = 'YNAB'
    else
      raise 'Invalid type'
    end
  end

  def create
    case params[:type]
    when Service::TYPE_YNAB
      par = params[:ynab_service].permit(:name, :api_key)
      @service = YnabService.new(par)
      @service.user = current_user
      @service.valid?
      #@service.save!
      respond_with @service, location: -> { services_path }
    else
      raise 'Invalid type'
    end
  end

end

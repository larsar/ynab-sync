require 'application_responder'

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :home_crumb, :breadcrumbs

  self.responder = ApplicationResponder
  respond_to :html

  self.responder = ApplicationResponder
  respond_to :html

  def home_crumb
    @breadcrumbs = []
    add_crumb "Home", '/'
  end

  def add_crumb(title, link)
    @breadcrumbs << {title: title, link: link}
  end

  def breadcrumbs
    # Override in controllers
  end

  def render_not_found
    render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
  end

  def render_forbidden
    render body: nil, status: :forbidden
  end
end

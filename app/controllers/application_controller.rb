require 'application_responder'

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  self.responder = ApplicationResponder
  respond_to :html

  self.responder = ApplicationResponder
  respond_to :html

  def render_not_found
    render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
  end

  def render_forbidden
    render body: nil, status: :forbidden
  end
end

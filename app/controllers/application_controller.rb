class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_user!

    rescue_from CanCan::AccessDenied do |exception|
        flash[:alert] = "You are not authorized to access this page."
        redirect_to root_path
    end
end

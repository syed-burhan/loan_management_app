class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @loans = Loan.excluding_admins
      @loans = @loans.where(state: params[:state]) if params[:state].present?
    else
      @loans = current_user.loans
    end
  end
end

class LoansController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
      @loans = Loan.excluding_admins
  end
  def show
      @loan = Loan.find_by(user_id: params[:id])
  end
end

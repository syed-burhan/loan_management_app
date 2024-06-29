class LoansController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    if current_user.admin?
      @loans = Loan.excluding_admins
      @loans = @loans.where(state: params[:state]) if params[:state].present?
    else
      @loans = current_user.loans
    end
  end

  def new
    @loan = Loan.new
  end

  def create
    @loan = current_user.loans.build(loan_params)
    @loan.interest_rate = 5
    if @loan.save
      redirect_to home_index_path, notice: 'Loan request submitted successfully.'
    else
      render :new
    end
  end

  def approve
    @loan = Loan.find(params[:id])
    if @loan.update(state: 'approved')
      redirect_to home_index_path, notice: 'Loan approved successfully.'
    else
      redirect_to home_index_path, alert: 'Unable to approve loan.'
    end
  end

  def reject
    @loan = Loan.find(params[:id])
    if @loan.update(state: 'rejected')
      redirect_to home_index_path, notice: 'Loan rejected successfully.'
    else
      redirect_to home_index_path, alert: 'Unable to reject loan.'
    end
  end

  def confirm_interest_rate
    @loan = Loan.find(params[:id])
    if @loan.update(state: 'open')
      redirect_to home_index_path, notice: 'Interest rate confirmed successfully.'
    else
      redirect_to home_index_path, alert: 'Unable to confirm interest rate.'
    end
  end

  def reject_interest_rate
    @loan = Loan.find(params[:id])
    if @loan.update(state: 'rejected')
      redirect_to home_index_path, notice: 'Interest rate rejected successfully.'
    else
      redirect_to home_index_path, alert: 'Unable to reject interest rate.'
    end
  end

  def repay
    @loan = Loan.find(params[:id])
    if @loan.update(state: 'closed')
      redirect_to home_index_path, notice: 'Loan repaid successfully.'
    else
      redirect_to home_index_path, alert: 'Unable to repay loan.'
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:loan_amount)
  end
end

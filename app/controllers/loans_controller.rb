class LoansController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_loan, only: [:approve, :reject, :confirm, :repay]

  # /loans
  def index
    if current_user.admin?
      @loans = Loan.excluding_admins
      @loans = @loans.where(state: params[:state]) if params[:state].present?
    else
      @loans = current_user.loans
    end
  end

  # /loans/new
  def new
    @loan = Loan.new
  end

  # /loans/create
  def create
    @loan = current_user.loans.new(loan_params)
    return redirect_to home_index_path, alert: 'Low Wallet balance, Unable to request loan.' if @loan.loan_amount > @loan.user.wallet.amount
    @loan.interest_rate = 5
    if @loan.save
      redirect_to home_index_path, notice: 'Loan request submitted successfully.'
    else
      render :new
    end
  end

  # /loans/:id/approve
  def approve
    return redirect_to home_index_path, alert: 'Low Wallet balance, Unable to approve loan.' if @loan.loan_amount > current_user.wallet.amount
    if @loan.update(loan_params.merge(state: 'approved'))
      redirect_to home_index_path, notice: 'Loan approved successfully.'
    else
      redirect_to home_index_path, alert: 'Unable to approve loan.'
    end
  end

  # /loans/:id/reject  
  def reject
    @loan = Loan.find(params[:id])
    if @loan.update(state: 'rejected')
      redirect_to home_index_path, notice: 'Loan rejected successfully.'
    else
      redirect_to home_index_path, alert: 'Unable to reject loan.'
    end
  end

  # /loans/:id/confirm
  def confirm
    loan_amount = @loan.loan_amount

    admin_wallet = User.admin.wallet
    user_wallet = @loan.user.wallet

    interest = (loan_amount * @loan.interest_rate) / 100

    if admin_wallet.update!(amount: admin_wallet.amount - loan_amount) &&
      user_wallet.update!(amount: user_wallet.amount + loan_amount) &&
      @loan.update!(total_amount: loan_amount + interest, state: 'open')

      schedule_jobs
      redirect_to home_index_path, notice: 'Interest rate confirmed successfully.'
    else
      redirect_to home_index_path, alert: 'Unable to confirm interest rate.'
    end
  end

  # /loans/:id/repay
  def repay
    total_amount = @loan.total_amount

    admin_wallet = User.admin.wallet
    user_wallet = @loan.user.wallet
    
    if admin_wallet.update!(amount: admin_wallet.amount + total_amount) &&
      user_wallet.update!(amount: user_wallet.amount - total_amount) &&
      @loan.update!(state: 'closed')
      redirect_to home_index_path, notice: 'Loan repaid successfully.'
    else
      redirect_to home_index_path, alert: 'Unable to repay loan.'
    end
  end

  private

  # Whitelist and permit the params
  def loan_params
    params.require(:loan).permit(:loan_amount, :interest_rate)
  end

  # Invoke Schedule jobs
  def schedule_jobs
    CalculateInterestJob.perform_in(2.minutes, @loan.id)
    DebitLoanAmountJob.perform_in(2.minutes, @loan.id)
  end

  # Set loan based on loan Id, send alert if not found
  def set_loan
    @loan = Loan.find(params[:id])
    redirect_to home_index_path, alert: 'Unable to find loan.' if @loan.blank?
  end
end

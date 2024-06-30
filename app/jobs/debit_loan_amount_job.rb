class DebitLoanAmountJob
  include Sidekiq::Job

  def perform(loan_id)
    loan = Loan.find(loan_id)
    user = loan.user
    if loan.open? && user.wallet.amount < loan.total_amount
      admin_wallet = User.admin.wallet
      admin_wallet.update!(amount: admin_wallet.amount + user.wallet.amount)
      user.wallet.update!(amount: 0)
      loan.update!(state: 'closed')

      # Schedule the next debit check only if the loan is still open
      DebitLoanAmountJob.perform_in(2.minutes, loan_id) if loan.open?
    end
  end
end

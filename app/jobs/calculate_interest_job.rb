class CalculateInterestJob
  include Sidekiq::Job

  def perform(loan_id)
    loan = Loan.find(loan_id)
    return unless loan.open?

    interest = (loan.loan_amount * loan.interest_rate) / 100
    loan.update!(total_amount: loan.total_amount + interest)

    # Schedule the next interest calculation only if the loan is still open
    CalculateInterestJob.perform_in(2.minutes, loan_id) if loan.open?
  end
end

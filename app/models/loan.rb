class Loan < ApplicationRecord
  belongs_to :user, inverse_of: :loans

  validates :state, presence: true
  validates :interest_rate, presence: true, numericality: { greater_than: 0, less_than: 10**8 }
  validates :loan_amount, presence: true, numericality: { greater_than: 0, less_than: 10**8 }

  enum state: { requested: 'Requested', approved: 'Approved', open: 'Open', closed: 'Closed', rejected: 'Rejected' }

  scope :excluding_admins, -> { joins(:user).where.not(users: { role_id: Role.find_by(name: 'Admin').id }) }

  def self.loan_exists?(user)
    user.loans.requested.exists? || user.loans.open.exists?
  end
end

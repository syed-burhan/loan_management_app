class Loan < ApplicationRecord
  belongs_to :user

  validates :state, presence: true
  validates :interest_rate, presence: true, numericality: true

  enum state: { requested: 'Requested', approved: 'Approved', open: 'Open', closed: 'Closed', rejected: 'Rejected' }
end

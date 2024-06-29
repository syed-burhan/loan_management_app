class Loan < ApplicationRecord
  belongs_to :user, inverse_of: :loans

  validates :state, presence: true
  validates :interest_rate, presence: true, numericality: true

  enum state: { requested: 'Requested', approved: 'Approved', open: 'Open', closed: 'Closed', rejected: 'Rejected' }

  scope :excluding_admins, -> { joins(:user).where.not(users: { role_id: Role.find_by(name: 'Admin').id }) }
end

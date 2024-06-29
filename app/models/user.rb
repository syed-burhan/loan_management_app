class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_one :wallet, dependent: :destroy
  has_many :loans, inverse_of: :user, dependent: :destroy

  belongs_to :role

  before_validation :assign_default_user_role, on: :create, if: -> { role_id.blank? }

  validates :name, presence: true
  validates :encrypted_password, presence: true, length: { minimum: 6 }

  after_create :create_default_loan, if: -> { role.name == "User" }
  after_create :create_default_wallet, if: -> { role.name == "User" }

  # Return boolean if User is Admin
  def admin?
    role.name == "Admin"
  end

  private

  # Assign default Role as User while registration
  def assign_default_user_role
    self.role = Role.find_by(name: "User")
  end

  # Creates default interest_rate for the registered user
  def create_default_loan
    loans.create!(interest_rate: 5)
  end

  # Creates default wallet amount for the registered user
  def create_default_wallet
    create_wallet!(amount: 10000)
  end
end

# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :read, Loan, user_id: user.id # Regular users can only read their own data
      can :create, Loan # Allow users to create new loans
      can :confirm_interest_rate, Loan
      can :reject_interest_rate, Loan
      cannot :index, Loan # Prevent regular users from accessing the index action
    end
  end
end

# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :read, Loan, user_id: user.id # Regular users can only read their own data
      cannot :index, Loan # Prevent regular users from accessing the index action
    end
  end
end

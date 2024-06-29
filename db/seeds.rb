# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

admin_role = Role.find_or_create_by!(name: "Admin")
Role.find_or_create_by!(name: "User")

admin = User.find_by(email: "admin@example.com")
if admin.nil?
    admin_user = User.create!(name: "Admin", email: "admin@example.com", password: "Admin@123", password_confirmation:"Admin@123", role: admin_role)
    admin_user.create_wallet!(amount: 1000000)
    admin_user.loans.create!(interest_rate: 5)
end

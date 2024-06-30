class CreateLoans < ActiveRecord::Migration[7.1]
  def change
    create_table :loans do |t|
      t.decimal :loan_amount, precision: 10, scale: 2
      t.decimal :total_amount, precision: 10, scale: 2, default: 0
      t.string :state, default: "Requested"
      t.decimal :interest_rate, precision: 5, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

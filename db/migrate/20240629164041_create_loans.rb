class CreateLoans < ActiveRecord::Migration[7.1]
  def change
    create_table :loans do |t|
      t.string :state, default: "Requested"
      t.decimal :interest_rate, precision: 5, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

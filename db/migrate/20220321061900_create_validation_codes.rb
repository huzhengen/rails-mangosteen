class CreateValidationCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :validation_codes do |t|
      t.string :email
      t.string :code, limit: 100
      t.datetime :used_at
      t.integer :kind, default: 1, null: false

      t.timestamps
    end
  end
end

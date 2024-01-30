class AddTokenTable < ActiveRecord::Migration[7.1]
  def change
    create_table :tokens do |t|
      t.integer :kind, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.string :code, null: false
      t.datetime :expires_at, null: false
    end

    add_index :tokens, [:kind, :user_id], unique: true
    add_index :tokens, :expires_at
    add_index :tokens, :code, unique: true
  end
end

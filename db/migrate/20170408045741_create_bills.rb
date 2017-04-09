class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.float :total
      t.float :paid
      t.float :balance
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
    add_index :bills, [:event_id,:user_id]
  end
end

class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, :limit =>  25
      t.string :location, :limit => 25
      t.float :total_amount, :limit => 15
      t.datetime :date

      t.timestamps
    end
  end
end

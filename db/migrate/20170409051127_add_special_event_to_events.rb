class AddSpecialEventToEvents < ActiveRecord::Migration
  def change
    add_column :events, :special_event, :boolean
    add_column :events, :status, :string
  end
end

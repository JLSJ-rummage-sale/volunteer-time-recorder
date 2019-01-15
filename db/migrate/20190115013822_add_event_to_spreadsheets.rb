class AddEventToSpreadsheets < ActiveRecord::Migration[5.1]
  def change
    add_reference :spreadsheets, :event, foreign_key: true
  end
end

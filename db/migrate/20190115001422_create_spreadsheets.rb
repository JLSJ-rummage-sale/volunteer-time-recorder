class CreateSpreadsheets < ActiveRecord::Migration[5.1]
  def change
    create_table :spreadsheets do |t|
      t.string :file_name
      t.integer :num_rows
      t.string :status

      t.timestamps
    end
  end
end

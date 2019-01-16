class CreateImportErrors < ActiveRecord::Migration[5.1]
  def change
    create_table :import_errors do |t|
      t.integer :row_number
      t.string :error_message
      t.string :row_data
      t.references :spreadsheet, foreign_key: true

      t.timestamps
    end
  end
end

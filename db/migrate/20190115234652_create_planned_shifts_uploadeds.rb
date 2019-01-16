class CreatePlannedShiftsUploadeds < ActiveRecord::Migration[5.1]
  def change
    create_table :planned_shifts_uploadeds do |t|
      t.references :spreadsheet, foreign_key: true
      t.references :planned_shift, foreign_key: true

      t.timestamps
    end
  end
end

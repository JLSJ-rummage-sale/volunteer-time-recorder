class CreateVolunteersUploadeds < ActiveRecord::Migration[5.1]
  def change
    create_table :volunteers_uploadeds do |t|
      t.references :spreadsheet, foreign_key: true
      t.references :volunteer, foreign_key: true

      t.timestamps
    end
  end
end

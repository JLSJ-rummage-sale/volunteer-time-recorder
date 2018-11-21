class CreatePlannedShifts < ActiveRecord::Migration[5.1]
  def change
    create_table :planned_shifts do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :name
      t.string :category
      t.text :notes
      t.references :event, foreign_key: true
      t.references :volunteer, foreign_key: true
      t.references :time_record, foreign_key: true

      t.timestamps
    end
  end
end

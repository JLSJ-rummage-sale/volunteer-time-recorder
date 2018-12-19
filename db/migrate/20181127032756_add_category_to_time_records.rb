class AddCategoryToTimeRecords < ActiveRecord::Migration[5.1]
  def change
    add_reference :time_records, :category, foreign_key: true
  end
end

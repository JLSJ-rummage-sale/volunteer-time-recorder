class RemoveCategoryFromTimeRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :time_records, :category, :string
  end
end

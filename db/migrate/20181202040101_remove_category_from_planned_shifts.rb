class RemoveCategoryFromPlannedShifts < ActiveRecord::Migration[5.1]
  def change
    remove_column :planned_shifts, :category, :string
  end
end

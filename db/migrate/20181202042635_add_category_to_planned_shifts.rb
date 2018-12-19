class AddCategoryToPlannedShifts < ActiveRecord::Migration[5.1]
  def change
    add_reference :planned_shifts, :category, foreign_key: true
  end
end

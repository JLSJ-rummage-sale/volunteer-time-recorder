class ChangeDataTypeForPlannedShiftTimes < ActiveRecord::Migration[5.1]
  def change
    change_column(:planned_shifts, :sign_in_time, :datetime)
  end
end

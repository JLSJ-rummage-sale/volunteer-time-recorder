class ChangeDataTypeForSignOutTime < ActiveRecord::Migration[5.1]
  def change
    change_column(:planned_shifts, :sign_out_time, :datetime)
  end
end

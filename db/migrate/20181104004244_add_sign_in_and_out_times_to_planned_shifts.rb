class AddSignInAndOutTimesToPlannedShifts < ActiveRecord::Migration[5.1]
  def change
    add_column :planned_shifts, :sign_in_time, :datetime
    add_column :planned_shifts, :sign_out_time, :datetime
  end
end

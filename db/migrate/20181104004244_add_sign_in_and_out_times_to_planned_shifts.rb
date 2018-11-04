class AddSignInAndOutTimesToPlannedShifts < ActiveRecord::Migration[5.1]
  def change
    add_column :planned_shifts, :sign_in_time, :date_time
    add_column :planned_shifts, :sign_out_time, :date_time
  end
end

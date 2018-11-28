class RemoveQuotaHoursFromMemberTypes < ActiveRecord::Migration[5.1]
  def change
    remove_column :member_types, :quota_hours, :integer
  end
end

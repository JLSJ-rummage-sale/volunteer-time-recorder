class ChangeQuotaToQuotas < ActiveRecord::Migration[5.1]
  def change
    rename_table :quota, :quotas
  end
end

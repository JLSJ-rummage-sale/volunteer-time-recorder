class AddCategoryToQuotas < ActiveRecord::Migration[5.1]
  def change
    add_reference :quotas, :category, foreign_key: true
  end
end

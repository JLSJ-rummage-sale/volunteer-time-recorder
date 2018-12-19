class AddMemberTypeToQuotas < ActiveRecord::Migration[5.1]
  def change
    add_reference :quotas, :member_type, foreign_key: true
  end
end

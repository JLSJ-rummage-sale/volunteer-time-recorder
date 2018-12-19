class CreateQuota < ActiveRecord::Migration[5.1]
  def change
    create_table :quota do |t|
      t.string :name
      t.integer :hours

      t.timestamps
    end
  end
end

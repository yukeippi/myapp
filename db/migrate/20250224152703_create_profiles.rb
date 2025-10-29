class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :bio
      t.integer :age

      t.timestamps
    end
  end
end

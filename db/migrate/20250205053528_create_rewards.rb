class CreateRewards < ActiveRecord::Migration[7.2]
  def change
    create_table :rewards do |t|
      t.string :description, null: false
      t.string :location, null: false
      t.date :completion_date, null: false
      t.string :invitation_token, null: false

      t.timestamps
    end

    add_index :rewards, :invitation_token, unique: true
  end
end

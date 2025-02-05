class CreateGoals < ActiveRecord::Migration[7.2]
  def change
    create_table :goals do |t|
      t.string :description, null: false
      t.integer :progress, null: false, default: 0
      t.integer :likings_count, null: false, default: 0
      t.integer :cheerings_count, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :reward, null: false, foreign_key: true

      t.timestamps
    end
  end
end

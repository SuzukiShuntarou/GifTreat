class CreateLikings < ActiveRecord::Migration[7.2]
  def change
    create_table :likings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :goal, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateRewardParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :reward_participants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reward, null: false, foreign_key: true

      t.timestamps
    end
    add_index :reward_participants, [:user_id, :reward_id], unique: true
  end
end

class AddIndexToRewardsCompletionDate < ActiveRecord::Migration[7.2]
  def change
    add_index :rewards, :completion_date
  end
end

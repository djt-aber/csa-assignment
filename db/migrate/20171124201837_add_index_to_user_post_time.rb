class AddIndexToUserPostTime < ActiveRecord::Migration[5.1]
  def change
    add_index :user_post_times, ["user_id", "post_id"], :unique => true
  end
end

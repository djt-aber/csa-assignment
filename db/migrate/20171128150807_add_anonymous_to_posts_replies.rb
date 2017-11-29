class AddAnonymousToPostsReplies < ActiveRecord::Migration[5.1]
  def change
    change_column :posts, :user_id, :integer, null: false
    add_column :posts, :anonymous, :boolean, default: false
    change_column :replies, :user_id, :integer, null: false
    add_column :replies, :anonymous, :boolean, default: false
  end
end

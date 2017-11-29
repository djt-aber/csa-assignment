class AddNullsBodyToPosts < ActiveRecord::Migration[5.1]
  def change
    change_column :posts, :body, :text, null: false
  end
end

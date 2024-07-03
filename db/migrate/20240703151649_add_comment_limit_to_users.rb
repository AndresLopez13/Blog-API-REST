class AddCommentLimitToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :comment_limit, :integer
  end
end

class AddNotNullConstraintsToBlogs < ActiveRecord::Migration[7.0]
  def change
    change_column_null :blogs, :title, false
    change_column_null :blogs, :body, false
  end
end

class RenameTextOnArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :text, :content
  end
end

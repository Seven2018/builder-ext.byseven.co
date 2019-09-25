class AddCommentsToSession < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :description, :text
    add_column :sessions, :teaser, :text
    remove_column :theories, :links
  end
end

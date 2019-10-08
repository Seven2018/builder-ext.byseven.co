class AddImageToSession < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :image, :string
    add_column :sessions, :address, :string
    add_column :sessions, :room, :string
    add_column :trainings, :mode, :string
  end
end

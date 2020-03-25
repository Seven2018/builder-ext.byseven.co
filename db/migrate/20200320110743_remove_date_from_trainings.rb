class RemoveDateFromTrainings < ActiveRecord::Migration[6.0]
  def change
    remove_column :trainings, :start_date
    remove_column :trainings, :end_date
  end
end

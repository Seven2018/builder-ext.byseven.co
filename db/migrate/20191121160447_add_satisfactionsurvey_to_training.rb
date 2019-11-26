class AddSatisfactionsurveyToTraining < ActiveRecord::Migration[6.0]
  def change
    add_column :trainings, :satisfaction_survey, :string
  end
end

class UpdateAirtableJob < ApplicationJob
  include SuckerPunch::Job

  def perform(training, trainer = false, numbers_sevener = false)
    training.export_airtable
    training.export_numbers_activity
    training.export_trainer_airtable if trainer.present?
    if numbers_sevener.present?
      training.trainers.select{|x| ['sevener', 'sevener+'].include?(x.access_level)}.each{|y| training.export_numbers_sevener(y)}
    end
  end
end

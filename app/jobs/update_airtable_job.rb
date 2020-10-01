class UpdateAirtableJob < ApplicationJob
  include SuckerPunch::Job

  def perform(training, numbers_sevener = false)
    if numbers_sevener.present?
      training.trainers.select{|x| ['sevener', 'sevener+'].include?(x.access_level)}.each{|y| training.export_numbers_sevener(y)}
    end
    training.export_airtable
    training.export_numbers_activity
  end
end

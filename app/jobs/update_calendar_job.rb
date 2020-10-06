class UpdateCalendarJob < ApplicationJob
  include SuckerPunch::Job

  def perform(session, url)
  end
end

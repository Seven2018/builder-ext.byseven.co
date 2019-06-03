class Session < ApplicationRecord
  belongs_to :project
  has_many :content_modules, -> { order(position: :asc) }, dependent: :destroy
  has_many :session_trainers, dependent: :destroy
  has_many :users, through: :session_trainers
  validate :date_included_in_project_dates?

  def date_included_in_project_dates?
    if date < project.start_date || date > project.end_date
      errors.add(:date, "must be included in project's dates")
    end
  end
end

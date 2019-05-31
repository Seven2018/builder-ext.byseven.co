class Session < ApplicationRecord
  belongs_to :project
  has_many :content_modules, -> { order(position: :asc) }, dependent: :destroy
  validate :date_included_in_project_dates?

  def date_included_in_project_dates?
    if date < project.start_date || date > project.end_date
      errors.add(:date, "must be included in project's dates")
    end
  end
end

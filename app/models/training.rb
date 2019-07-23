class Training < ApplicationRecord
  belongs_to :client_contact
  has_many :sessions, :dependent => :destroy
  has_many :training_ownerships, :dependent => :destroy
  has_many :users, through: :training_ownerships
  has_many :session_trainers, through: :sessions
  has_many :invoice_items
  has_many :invoices
  validates :title, :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  def start_time
    self.start_date
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end

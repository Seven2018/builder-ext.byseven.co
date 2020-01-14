class Training < ApplicationRecord
  belongs_to :client_contact
  has_many :sessions, dependent: :destroy
  has_many :training_ownerships, dependent: :destroy
  has_many :users, through: :training_ownerships
  has_many :session_trainers, through: :sessions
  has_many :invoice_items
  has_many :invoices
  has_many :forms, dependent: :destroy
  validates :title, :start_date, :end_date, presence: true
  validate :end_date_after_start_date
  accepts_nested_attributes_for :training_ownerships

  def start_time
    self.start_date
  end

  def end_time
    self.end_date
  end

  def client_company
    self.client_contact.client_company
  end

  def title_for_copy
    self.title + ' - ' + self.end_date.strftime('%d/%m/%y')
  end

  def trainers
    trainers = []
    self.sessions.each do |session|
      session.session_trainers.each do |trainer|
        trainers << trainer.user
      end
    end
    trainers.uniq
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end

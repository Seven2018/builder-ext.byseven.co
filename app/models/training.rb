class Training < ApplicationRecord
  belongs_to :client_contact
  has_many :sessions, dependent: :destroy
  has_many :training_ownerships, dependent: :destroy
  has_many :users, through: :training_ownerships
  has_many :session_trainers, through: :sessions
  has_many :invoice_items
  has_many :invoices
  has_many :forms, dependent: :destroy
  validates :title, presence: true
  accepts_nested_attributes_for :training_ownerships

  def start_time
    self.sessions&.order(date: :asc)&.first&.date
  end

  def end_time
    self.sessions&.order(date: :asc)&.last&.date
  end

  def self.numbers_scope(starts_at = Date.today.beginning_of_year, ends_at = Date.today.end_of_year)
    Training.joins(:sessions).where('sessions.date < ?', ends_at).where('sessions.date > ?', starts_at).uniq
  end

  def client_company
    self.client_contact.client_company
  end

  def title_for_copy
    if self.sessions.empty?
      self.title + ' - ' + Training.where(title: self.title).count.to_s
    else
      self.title + ' - ' + Training.where(title: self.title).count.to_s
    end
  end

  def owners
    self.training_ownerships.where(user_type: 'Owner').map(&:user)
  end

  def writers
    self.training_ownerships.where(user_type: 'Writer').map(&:user)
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
end

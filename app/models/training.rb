class Training < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :training_ownerships, dependent: :destroy
  has_many :users, through: :training_ownerships
  has_many :session_trainers, through: :sessions
  validates :title, presence: true
  validates :vat, inclusion: { in: [ true, false ] }
  validates_uniqueness_of :refid
  accepts_nested_attributes_for :training_ownerships

  def start_time
    Session.where(training_id: self).where.not(date: nil).order(date: :asc).first&.date
  end

  def end_time
    Session.where(training_id: self).where.not(date: nil).order(date: :asc).last&.date
  end

  def next_session
    if self.end_time.present? && self.end_time >= Date.today
      return self.sessions&.where('date >= ?', Date.today)&.order(date: :asc).first&.date
    elsif self.end_time.present?
      return self.end_time
    else
      return Date.today
    end
  end

  def to_date?
    if self.sessions.where(date: nil).present?
      return true
    else
      return false
    end
  end

  def owners
    self.training_ownerships.where(user_type: 'Owner').map(&:user)
  end

  def owner_ids
    self.training_ownerships.where(user_type: 'Owner').map(&:user_id)
  end

  def writers
    self.training_ownerships.where(user_type: 'Writer').map(&:user)
  end

  def writer_ids
    self.training_ownerships.where(user_type: 'Writer').map(&:user_id)
  end

  def trainers
    SessionTrainer.where(session_id: [self.sessions.ids]).map{|x| x.user}.uniq
  end

  def hours
    self.sessions.map{|x| x.duration * x.session_trainers.count}.sum
  end
end

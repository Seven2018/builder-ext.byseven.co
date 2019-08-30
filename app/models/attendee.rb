class Attendee < ApplicationRecord
  belongs_to :client_company
  has_many :session_attendees
  has_many :sessions, through: :session_attendees
  validates :firstname, :lastname, :email, presence: true
  validates_uniqueness_of :email
  before_save :make_capitalize
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      # Attendee.create! row.to_hash
      attendee = Attendee.new(row.to_hash)
      attendee.save
    end
  end

  def make_capitalize
    self.firstname.capitalize!
    self.lastname.upcase!
    self.email.downcase!
  end
end

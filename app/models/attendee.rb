class Attendee < ApplicationRecord
  belongs_to :client_company
  has_many :session_attendees
  has_many :sessions, through: :session_attendees
  has_many :attendee_interests, dependent: :destroy
  validates :firstname, :lastname, :email, presence: true
  validates_uniqueness_of :email
  before_save :make_capitalize
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      attendee = Attendee.new(row.to_hash)
      attendee.save
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end

  def make_capitalize
    self.firstname.capitalize!
    self.lastname.upcase!
    self.email.downcase!
  end
end

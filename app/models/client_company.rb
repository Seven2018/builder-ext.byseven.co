class ClientCompany < ApplicationRecord
  has_many :client_contacts, dependent: :destroy
  has_many :invoice_items
  has_many :attendees, dependent: :destroy
  validates :client_company_type, inclusion: { in: %w(Company School) }

  def trainings_for_copy
    array = []
    self.client_contacts.each do |contact|
      array << contact.trainings
    end
    array = array.flatten(1).sort_by{ |x| x.title }
    array.map do |training|
      training.title = training.title + ' - ' + training.end_date.strftime('%d/%m/%y')
    end
    array
  end
end

class Training < ApplicationRecord
  belongs_to :client_contact
  has_many :sessions, dependent: :destroy
  has_many :training_ownerships, dependent: :destroy
  has_many :users, through: :training_ownerships
  has_many :session_trainers, through: :sessions
  has_many :attendee_interests, dependent: :destroy
  has_many :invoice_items
  has_many :invoices
  has_many :forms, dependent: :destroy
  has_many :attendee_interests, dependent: :destroy
  validates :title, presence: true
  validates :vat, inclusion: { in: [ true, false ] }
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
      self.title + ' : ' + Training.where(title: self.title).count.to_s + '(empty)'
    else
      self.title + ' : ' + self.sessions.order(date: :asc).first.date&.strftime('%d/%m/%y') + ' - ' + self.sessions.order(date: :asc).last.date&.strftime('%d/%m/%y')
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
    trainers = []
    self.sessions.each do |session|
      session.session_trainers.each do |trainer|
        trainers << trainer.user
      end
    end
    trainers.uniq
  end

  def attendees
    attendees = []
    self.sessions.each do |session|
      session.session_attendees.each do |session_attendee|
        attendees << session_attendee.attendee
      end
    end
    attendees.uniq
  end

  def self.numbers_activity_csv(starts_at, ends_at)
    attributes = %w(Title Client Dates Owner Trainers Hours Comments)
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |item|
        title = item.title
        client = item.client_company.name
        dates = ""
        owner = ""
        trainers = ""
        hours = ""
        comments = ""
        item.sessions.where('date >= ?', starts_at.to_date).where('date <= ?', ends_at.to_date).order(date: :asc).each do |session|
          dates += session&.date&.strftime('%d/%m/%y') + "\n"
          i = 1
          session.session_trainers.map(&:user).each do |trainer|
            trainers += trainer.fullname + "\n"
            hours += session.duration.to_s + "\n"
            if i > 1
              dates += session&.date&.strftime('%d/%m/%y') + "\n"
            end
            i += 1
          end
        end
        item.owners.each do |user|
          owner += user.fullname + "\n"
        end
        unless dates.empty?
          csv << [title, client, dates, owner, trainers, hours, comments]
        end
      end
    end
  end

  def export_airtable
    existing_card = OverviewCard.all.select{|x| x['Reference SEVEN'] == self.refid}&.first
    details = "Détail des sessions (date, horaires, intervenants):\n\n"
    seveners_to_pay = "Seveners à payer :\n"
    seven_invoices = "Factures SEVEN :\n"
    self.invoice_items.where(type: 'Invoice').order(:id).each do |invoice|
      invoice.status == 'Paid' ? seven_invoices += "[x] #{invoice.uuid}" : seven_invoices += "[ ] #{invoice.uuid}"
    end
    to_date, to_staff, seveners = false, false, false
    self.sessions.each do |session|
      if session.date.present?
        details += "- #{session.date.strftime('%d/%m/%Y')} de #{session.start_time.strftime('%Hh%M')} à #{session.end_time.strftime('%Hh%M')}"
        if session.session_trainers.present?
          details += " - #{(session.session_trainers.map{|x| x.initials}).join(', ')}\n"
        else
          details += " - A STAFFER\n"
          to_staff = true
        end
      else
        to_date = true
      end
    end
    seveners = true if self.trainers.map{|x|x.access_level}.to_set.intersect?(['sevener+', 'sevener'].to_set)
    if seveners
      self.trainers.where(access_level: ['sevener+', 'sevener']).each do |user|
        unit_price = SessionTrainer.find_by(user_id: user.id, session_id: session.id).unit_price
        seveners_to_pay += "[ ] #{user.fullname} : #{user.hours(self)}h x #{unit_price}€ = #{session.duration*unit_price}€\n"
      end
    else
      seveners_to_pay += "[ ] Aucun\n"
    end
    if existing_card.present?
      existing_card['Due Date'] = self.end_time.strftime('%Y-%m-%d') if self.end_time.present?
      existing_card['Details'] = details
      if to_date
        existing_card['Status'] = 'En attente (dates) - ALL'
      elsif to_staff
        existing_card['Status'] = 'En attente (staff) - ALL'
      elsif seveners
        existing_card['Status'] = 'En attente réalisation (avec sevener)'
      else
        existing_card['Status'] = 'En attente réalisation (sans sevener)'
      end
      existing_card['Seveners to pay'] = seveners_to_pay
      existing_card['Seven Invoices'] = seven_invoices
      existing_card.save
    else
      card = OverviewCard.create("Title" => self.title, "Reference SEVEN" => self.refid, "VAT" => self.vat, "Unit Price" => self.unit_price, "Details" => details, 'Export to Builder' => 'Updated')
      card['Due Date'] = self.end_time.strftime('%Y-%m-%d') if self.end_time.present?
      contact = OverviewContact.all.select{|x| x['Name'] == self.client_contact.name}
      client = OverviewClient.all.select{|x| x['Name'] == @training.client_contact.client_company.name}
      if contact.present?
        card['Customer Contact'] = contact.first
        card['Company/School'] = contact.first['Company/School']
      else
        builder_client = @training.client_contact.client_company
        unless client.present?
          new_client = OverviewClient.create('Name' => builder_client.name, 'Type' => builder_client.client_company_type, 'Address' => builder_client.address, 'Zipcode' => builder_client.zipcode, 'City' => builder_client.city, 'Builder_id' => builder_client.id)
          new_client.save
          new_contact = OverviewContact.create('Name' => @training.client_contact.name, 'Email' => @training.client_contact.email, 'Builder_id' => @training.client_contact.id, 'Company/School' => [new_client.id])
          new_contact.save
          card['Customer Contact'] = [new_contact.id]
        else
          new_contact = OverviewContact.create('Name' => @training.client_contact.name, 'Email' => @training.client_contact.email, 'Builder_id' => @training.client_contact.id, 'Company/School' => [client.first.id])
          card['Customer Contact'] = [new_contact.id]
        end
      end
      card['Seveners to pay'] = seveners_to_pay
      card['Seven Invoices'] = seven_invoices
      card.save
    end
  end
end

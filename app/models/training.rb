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
    self.sessions&.order(date: :asc)&.reject{|x|x.date == nil}&.first&.date
  end

  def end_time
    self.sessions&.order(date: :asc)&.reject{|x|x.date == nil}&.last&.date
  end

  def self.numbers_scope(starts_at = Date.today.beginning_of_year, ends_at = Date.today.end_of_year)
    Training.joins(:sessions).where('sessions.date < ?', ends_at).where('sessions.date > ?', starts_at).uniq
  end

  def client_company
    self.client_contact.client_company
  end

  def title_for_copy
    # if self.sessions.empty?
    #   self.title + ' : ' + Training.where(title: self.title).count.to_s + '(empty)'
    # else
    #   self.title + ' : ' + self.sessions.order(date: :asc).first.date&.strftime('%d/%m/%y') + ' - ' + self.sessions.order(date: :asc).last.date&.strftime('%d/%m/%y')
    # end
    self.title + ' : ' + self.refid
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
    # begin
      existing_card = OverviewTraining.all.select{|x| x['Reference SEVEN'] == self.refid}&.first
      existing_contact = OverviewContact.find(existing_card['Partner Contact'].join)
      overview_update = true
      details = "Détail des sessions (date, horaires, intervenants):\n\n"
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
      if existing_card.present?
        if self.client_contact.id != existing_contact['Builder_id']
          new_contact = OverviewContact.all.select{|x| x['Builder_id'] == self.client_contact.id}
          existing_card['Partner Contact'] = [new_contact.id]
        end
        existing_card['Title'] = self.title
        existing_card['Unit Price'] = self.unit_price
        existing_card['VAT'] = self.vat
        existing_card['Due Date'] = self.end_time.strftime('%Y-%m-%d') if self.end_time.present?
        overview_update = false if existing_card['Builder Sessions Datetime'] != details
        existing_card['Builder Sessions Datetime'] = details
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
        card = OverviewTraining.create("Title" => self.title, "Reference SEVEN" => self.refid, "VAT" => self.vat, "Unit Price" => self.unit_price, "Details" => details, 'Export to Builder' => 'Updated')
        card['Due Date'] = self.end_time.strftime('%Y-%m-%d') if self.end_time.present?
        contact = OverviewContact.all.select{|x| x['Name'] == self.client_contact.name}
        client = OverviewClient.all.select{|x| x['Name'] == self.client_contact.client_company.name}
        if contact.present?
          card['Customer Contact'] = [contact.first.id]
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
        overview_update ? card['Overview - TF - updated'] = true : card['Overview - TF - updated'] = nil
        card.save
      end
    # rescue
    # end
  end

  def export_trainer_airtable
    begin
      existing_card = OverviewTraining.all.select{|x| x['Reference SEVEN'] == self.refid}&.first
      seveners_to_pay = ""
      seveners = true if self.trainers.map{|x|x.access_level}.to_set.intersect?(['sevener+', 'sevener'].to_set)
      array = []
      if seveners
        self.trainers.select{|x|['sevener+', 'sevener'].include?(x.access_level)}.each do |user|
          # unit_price = SessionTrainer.find_by(user_id: user.id, session_id: self.sessions.ids).unit_price
          seveners_to_pay += "[ ] #{user.fullname} : #{user.hours(self)}h x #{unit_price}€ = #{user.hours(self)*unit_price}€\n"
          trainer = OverviewUser.all.select{|x| x['Builder_id'] == user.id }&.first
          array << user.id
          intervention = OverviewIntervention.all.select{|x| x['Training_refid'] == self.refid && x['User_id'] == "#{user.id}"}&.first
          if intervention.nil?
            intervention = OverviewIntervention.create('Training' => [existing_card.id], 'User' => [trainer.id], 'Billing Type' => 'Hourly', 'Training_refid' => self.refid, 'User_id' => "#{user.id}")
            self.client_contact.client_company.client_company_type == 'Company' ? intervention['Rate'] = 80 : intervention['Rate'] = 40
          end
          intervention['Number of hours'] = user.hours(self)
          intervention.save
        end
      else
        seveners_to_pay += "[ ] Aucun\n"
      end
      OverviewIntervention.all.select{|x| x['Training_refid'] == self.refid && array.exclude?(x['User_id'].to_i)}.each{|y| y.destroy}
    rescue
    end
  end

  def export_numbers_activity
    begin
      to_delete = OverviewNumbersActivity.all.select{|x| x['Builder_id'] == self.refid}
      to_delete.each{|x| x.destroy}
      card = OverviewTraining.all.select{|x| x['Reference SEVEN'] == self.refid}&.first
      self.sessions.each do |session|
        if session.date.present?
          session.trainers.each do |trainer|
            OverviewNumbersActivity.create('Training' => [card.id], )
          end
        end
      end
    rescue
    end
  end
end

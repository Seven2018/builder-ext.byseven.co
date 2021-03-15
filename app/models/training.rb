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
  validates_uniqueness_of :refid
  accepts_nested_attributes_for :training_ownerships

  def start_time
    Session.where(training_id: self).order(date: :asc).first&.date
  end

  def end_time
    Session.where(training_id: self).order(date: :asc).last&.date
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

  def client_company
    self.client_contact.client_company
  end

  def title_for_copy
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
    SessionTrainer.where(session_id: [self.sessions.ids]).map{|x| x.user}.uniq
  end

  def attendees
    SessionAttendee.where(session_id: [self.sessions.ids]).map{|x| x.attendee}.uniq
  end

  def hours
    self.sessions.map{|x| x.duration * x.session_trainers.count}.sum
  end

  def export_airtable
    # begin
      existing_card = OverviewTraining.all.select{|x| x['Reference SEVEN'] == self.refid}&.first
      details = "Détail des sessions (date, horaires, intervenants):\n\n"
      seven_invoices = "Factures SEVEN :\n"
      OverviewNumbersRevenue.all.select{|x| x['Training_id'] == self.id}.sort_by{|x| x['Invoice_id']}.each do |invoice|
        builder_invoice = InvoiceItem.find(invoice['Invoice_id'])
        invoice['Paid'] == true ? seven_invoices += "[x] #{builder_invoice.uuid} \n" : seven_invoices += "[ ] #{builder_invoice.uuid} \n"
      end
      self.sessions.each do |session|
        if session.date.present?
          details += "- #{session.date.strftime('%d/%m/%Y')} de #{session.start_time.strftime('%Hh%M')} à #{session.end_time.strftime('%Hh%M')}"
          if session.session_trainers.present?
            trainers = ""
            session.session_trainers.each do |trainer|
              user = OverviewUser.all.select{|x| x['Builder_id'] == trainer.user.id}&.first
              if user['Tag'].present?
                trainers += "#{user['Tag']}, "
              else
                trainers += trainer.user.fullname + ', '
              end
            end
            trainers = trainers.chomp(', ')
            details += " - " + trainers + ' (' + session.duration.to_s + 'h)' + "\n"
          else
            details += " - A STAFFER"  + ' (' + session.duration.to_s + 'h)' + "\n"
          end
        end
      end

      self.update(title: existing_card['Title'])
      owners = existing_card['Owner']&.map{|owner| User.find(OverviewUser.find(owner)['Builder_id'])}
      if owners.present?
        owners.each do |owner|
          unless TrainingOwnership.where(training_id: self.id, user_id: owner.id, user_type: 'Owner').present?
            TrainingOwnership.create(training_id: self.id, user_id: owner.id, user_type: 'Owner')
          end
        end
      end
      TrainingOwnership.where(training_id: self.id, user_type: 'Owner').where.not(user_id: owners&.map{|x| x.id}).destroy_all
      writers = existing_card['Writers']&.map{|writer| User.find(OverviewUser.find(writer)['Builder_id'])}
      if writers.present?
        writers.each do |writer|
          unless TrainingOwnership.where(training_id: self.id, user_id: writer.id, user_type: 'Writer').present?
            TrainingOwnership.create(training_id: self.id, user_id: writer.id, user_type: 'Writer')
          end
        end
      end
      TrainingOwnership.where(training_id: self.id, user_type: 'Writer').where.not(user_id: writers&.map{|x| x.id}).destroy_all
      existing_card['Trainers'] = self.trainers.map{|x| OverviewUser.all.select{|y| y['Builder_id'] == x.id}.first.id}
      existing_card['Due Date'] = self.end_time.strftime('%Y-%m-%d') if self.end_time.present?
      existing_card['Builder Sessions Datetime'] = details
      existing_card['Builder Update'] = Time.now.utc.iso8601(3)

      seveners_to_pay = ""
      seveners = true if self.trainers.map{|x|x.access_level}.to_set.intersect?(['sevener+', 'sevener'].to_set)
      if seveners
        self.trainers.select{|x|['sevener+', 'sevener'].include?(x.access_level)}.each do |user|
          numbers_card = OverviewNumbersSevener.all.select{|x| x['User_id'] == user.id && x['Training_id'] == self.id}&.first

          if numbers_card['Total Due (incl. VAT)'] == numbers_card['Total Paid']
            if numbers_card['Billing Type'] == 'Hourly'
              seveners_to_pay += "[x] #{user.fullname} : #{numbers_card['Unit Number']}h x #{numbers_card['Unit Price']}€ = #{numbers_card['Unit Number']*numbers_card['Unit Price']}€\n"
            elsif numbers_card['Billing Type'] == 'Flat rate'
              seveners_to_pay += "[x] #{user.fullname} : #{numbers_card['Unit Price']}€\n"
            end
          else
            if numbers_card['Billing Type'] == 'Hourly'
              seveners_to_pay += "[ ] #{user.fullname} : #{numbers_card['Unit Number']}h x #{numbers_card['Unit Price']}€ = #{numbers_card['Unit Number']*numbers_card['Unit Price']}€ (Montant restant du : #{numbers_card['Total Due (incl. VAT)'] - numbers_card['Total Paid']}€)\n"
            elsif numbers_card['Billing Type'] == 'Flat rate'
              seveners_to_pay += "[ ] #{user.fullname} : #{numbers_card['Unit Price']}€\n"
            end
          end
        end
      else
        seveners_to_pay += "[x] Aucun\n"
      end
      existing_card['Seveners to pay'] = seveners_to_pay unless seveners_to_pay == ''
      existing_card['SEVEN Invoice(s)'] = seven_invoices
      existing_card.save
    # rescue
    # end
  end

  def export_numbers_activity
    # begin
      # to_delete = OverviewNumbersActivity.all.select{|x| x['Builder_id'] == [self.id]}
      to_delete = OverviewNumbersActivity.all(filter: "{Builder_id} = #{self.id}")
      to_delete.each{|x| x.destroy}
      # card = OverviewTraining.all.select{|x| x['Builder_id'] == self.id}&.first
      card = OverviewTraining.all(filter: "{Builder_id} = '#{self.id}'")&.first
      self.sessions.each do |session|
        if session.date.present?
          session.session_trainers.each do |trainer|
            # new_activity = OverviewNumbersActivity.create('Training' => [card.id], 'Date' => session.date.strftime('%Y-%m-%d'), 'Trainer' => [OverviewUser.all.select{|x| x['Builder_id'] == trainer.user_id}&.first&.id], 'Hours' => session.duration)
            new_activity = OverviewNumbersActivity.create('Training' => [card.id], 'Date' => session.date.strftime('%Y-%m-%d'), 'Trainer' => [OverviewUser.all(filter: "Builder_id = '#{trainer.user_id}'")&.first&.id], 'Hours' => session.duration)
            if card['Unit Type'] == 'Hour'
              new_activity['Revenue'] = new_activity['Hours'] * card['Unit Price']
            elsif ['Participant', 'Half day', 'Day'].include?(card['Unit Type'])
              new_activity['Revenue'] = card['Unit Number'] * card['Unit Price'] / (self.sessions.map{|x| x.duration}.sum * session.users.count) * session.duration
            end
            new_activity.save
          end
        end
      end
    # rescue
    # end
  end

  def export_numbers_sevener(user)
    # begin
      # cards = OverviewNumbersSevener.all.select{|x| x['Reference SEVEN'] == [self.refid]}
      cards = OverviewNumbersSevener.all(filter: "{Reference SEVEN} = '#{self.refid}'")
      cards.each do |trainer|
        unless self.trainers.map{|x| x.id}.include?(OverviewUser.find(trainer['Sevener'].join)['Builder_id'])
          trainer.destroy
        end
      end
      if ['sevener', 'sevener+'].include?(user.access_level)
        # sevener = OverviewUser.all.select{|x| x['Builder_id'] == user.id}&.first
        sevener = OverviewUser.all(filter: "{Builder_id} = '#{user.id}'")&.first
        card = OverviewNumbersSevener.all.select{|x| x['Reference SEVEN'] == [self.refid] && x['Sevener'] == [sevener.id]}&.first
        invoices = OverviewInvoiceSevener.all.select{|x| x['Training Reference'] == [self.refid] && x['Sevener'] == [sevener.id]}
        dates = ''
        unless card.present?
          card = OverviewNumbersSevener.create('Training' => [OverviewTraining.all.select{|x| x['Builder_id'] == self.id}&.first.id], 'Sevener' => [sevener.id], 'Billing Type' => 'Hourly')
          self.client_contact.client_company.client_company_type == 'Company' ? card['Unit Price'] = 80 : card['Unit Price'] = 40
        end
        unless card['Billing Type'] == 'Flat rate'
          card['Unit Number'] = user.hours(self)
        end
        card['Invoices Sevener'] = invoices.map{|x| x.id}
        card['Total Paid'] = invoices.select{|x| x['Amount'] if x['Status'] == 'Paid'}.map{|x| x['Amount']}.sum
        self.sessions.each do |session|
          dates += session.date.strftime('%d/%m/%Y') + "\n" if session.users.include?(user) if session.date.present?
        end
        card['Dates'] = dates
        card['User_id'] = user.id
        card['Training_id'] = self.id
        card.save
      end
    # rescue
    # end
  end
end

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :survey, :contact_form, :contact_form_seven_x_bam]

  def home
  end

  def billing
    @user = User.find(params[:user_id])
    @trainings = Training.select{|x| x.trainers.include?(@user)}
  end

  def contact_form
    unless params[:email_2].present? || params[:email].empty?
      contact = IncomingContact.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message], 'Training' => params[:training], 'Date' => DateTime.now.strftime('%Y-%m-%d'))
      # IncomingContactMailer.with(user: User.find(2)).new_incoming_contact(contact).deliver
      # IncomingContactMailer.with(user: User.find(3)).new_incoming_contact(contact).deliver
      # IncomingContactMailer.with(user: User.find(4)).new_incoming_contact(contact).deliver
    else
      IncomingSpam.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message])
    end
    redirect_to 'https://learn.byseven.co/thank-you.html'
  end

  def contact_form_seven_x_bam
    unless params[:email_2].present?
      contact = IncomingContactBam.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message], 'Choice' => params[:choice])
      # IncomingContactMailer.with(user: User.find(2)).new_incoming_contact(contact).deliver
    else
      IncomingSpam.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message])
    end
    redirect_to 'https://learn.byseven.co/thank-you.html'
  end

  def survey
    redirect_to 'https://docs.google.com/forms/d/1knOYJWvoVV7T3IVCbNqoMtTbgMiDG6zroZSPrRJm5vY/edit'
  end

  def dashboard_sevener
  end

  def airtable_import_users
    OverviewUser.all.each do |user|
      if user['Builder_id'].nil?
        new_user = User.new(firstname: user['Firstname'], lastname: user['Lastname'], email: user['Email'], access_level: 'sevener', password: 'tititoto')
        new_user.save
      end
    end
    redirect_back(fallback_location: root_path)
    flash[:notice] = "Data imported from Airtable."
  end

  def airtable_import_clients
    OverviewClient.all.each do |client|
      if client['Builder_id'].nil?
        company = ClientCompany.new(name: client['Name'], client_company_type: client['Type'], address: client['Address'], zipcode: client['Zipcode'], city: client['City'], auth_token: SecureRandom.hex(5).upcase)
        company.opco_id = OverviewOpco.find(client['OPCO'].join) if client['OPCO'].present?
        company.save
        client['Builder_id'] = company.id
        client.save
      else
        company = ClientCompany.find(client['Builder_id'])
        company.update(name: client['Name'], client_company_type: client['Type'], address: client['Address'], zipcode: client['Zipcode'], city: client['City'], opco_id: OverviewOpco.find(client['OPCO'].join))
      end
    end

    OverviewContact.all.each do |contact|
      if contact['Builder_id'].nil?
        new_contact = ClientContact.new(name: contact['Firstname']+' '+contact['Lastname'], email: contact['Email'], client_company_id: OverviewClient.find(contact['Company/School'].join)['Builder_id'])
        new_contact.save
        contact['Builder_id'] = new_contact.id
        contact.save
      else
        existing_contact = ClientContact.find(contact['Builder_id'])
        existing_contact.update(name: contact['Firstname']+contact['Lastname'], email: contact['Email'], client_company_id: OverviewClient.find(contact['Company/School'].join)['Builder_id'])
      end
    end
    redirect_back(fallback_location: root_path)
    flash[:notice] = "Data imported from Airtable."
  end

  def import_airtable
    skip_authorization
    OverviewTraining.all.each do |card|
      if card['Builder_id'].present?
        training = Training.find(card['Builder_id'])
        training.update(title: card['Title']) if training.title != card['Title']
        training.update(unit_price: card['Unit Price']) if training.unit_price != card['Unit Price']
      elsif card['Partner Contact'].present?
        owners = OverviewUser.all.select{|x| if card['Owner'].present?; card['Owner'].include?(x.id); end}
        writers = OverviewUser.all.select{|x| if card['Writers'].present?; card['Writers'].include?(x.id); end}
        contact = OverviewContact.find(card['Partner Contact'].join)
        company = OverviewClient.find(contact['Company/School'].join)
        if contact['Builder_id'].nil?
          if company['Builder_id'].nil?
            reference = (ClientCompany.where.not(reference: nil).order(id: :asc).last.reference[-5..-1].to_i + 1).to_s.rjust(5, '0') if ClientCompany.all.count != 0
            new_company = ClientCompany.create(name: company['Name'], address: company['Address'], zipcode: company['Zipcode'], city: company['City'], client_company_type: company['Type'], description: '', reference: reference)
            company['Builder_id'] = new_company.id
            company.save
          end
          new_contact = ClientContact.new(name: contact['Firstname'] + ' ' + contact['Lastname'], email: contact['Email'], client_company_id: company['Builder_id'], title: '', role_description: '')
          new_contact.save
          contact['Builder_id'] = new_contact.id
          contact.save
        end
        company['Type'] == 'School' ? vat = false : vat = true
        vat = true if card['VAT'] == true
        training = Training.new(title: card['Title'], client_contact_id: contact['Builder_id'], refid: "#{Time.current.strftime('%y')}-#{(Training.last.refid[-4..-1].to_i + 1).to_s.rjust(4, '0')}", satisfaction_survey: 'https://learn.byseven.co/survey', unit_price: card['Unit Price'].to_f, mode: 'Company', vat: vat)
        if training.save
          Session.create(title: 'Session 1', duration: 0, training_id: training.id)
          card['Reference SEVEN'] = training.refid
          card['Builder_id'] = training.id
          card['Builder Update'] = Time.now.utc.iso8601(3)
          card.save
          owners.each do |owner|
            TrainingOwnership.create(training_id: training.id, user_id: owner['Builder_id'], user_type: 'Owner')
          end
          writers.each do |writer|
            TrainingOwnership.create(training_id: training.id, user_id: writer['Builder_id'], user_type: 'Writer')
          end
        end
      end
    end
    redirect_to trainings_path(page: 1)
  end

  def numbers_activity
    if params[:numbers_activity].present?
      @starts_at = params[:numbers_activity][:starts_at]
      @ends_at = params[:numbers_activity][:ends_at]
      @trainings = Training.numbers_scope(@starts_at, @ends_at)
    else
      @starts_at = Date.today.beginning_of_year
      @ends_at = Date.today
      @trainings = Training.numbers_scope
    end
    respond_to do |format|
      format.html
      format.csv { send_data Training.where(id: @trainings.map(&:id)).numbers_activity_csv(params[:starts], params[:ends]), filename: "Numbers Activity #{params[:starts].split('-').join()} - #{params[:ends].split('-').join()}" }
    end
  end

  def numbers_sales
    if params[:numbers_sales].present?
      @starts_at = params[:numbers_sales][:starts_at]
      @ends_at = params[:numbers_sales][:ends_at]
      @invoices = InvoiceItem.numbers_scope(@starts_at, @ends_at)
    else
      @starts_at = Date.today.beginning_of_year
      @ends_at = Date.today
      @invoices = InvoiceItem.numbers_scope(@starts_at, @ends_at)
    end
  end
end



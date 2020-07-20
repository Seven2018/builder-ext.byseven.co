class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :survey, :kea_partners_c, :kea_partners_m, :kea_partners_d, :kea_partners_thanks, :contact_form, :contact_form_seven_x_bam]

  def home
  end

  def overlord
  end

  def contact_form
    unless params[:email_2].present?
      contact = IncomingContact.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message], 'Training' => params[:training], 'Date' => DateTime.now.strftime('%Y-%m-%d'))
      IncomingContactMailer.with(user: User.find(2)).new_incoming_contact(contact).deliver
    else
      IncomingSpam.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message])
    end
    redirect_to 'https://learn.byseven.co/thank-you.html'
  end

  def contact_form_seven_x_bam
    unless params[:email_2].present?
      contact = IncomingContactBam.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message], 'Choice' => params[:choice])
      IncomingContactMailer.with(user: User.find(2)).new_incoming_contact(contact).deliver
    else
      IncomingSpam.create('Name' => params[:name], 'Email' => params[:email], 'Message' => params[:message])
    end
    redirect_to 'https://learn.byseven.co/thank-you.html'
  end

  def kea_partners_c
    session[:my_previous_url] = kea_partners_c_path
  end

  def kea_partners_m
    session[:my_previous_url] = kea_partners_m_path
  end

  def kea_partners_d
    session[:my_previous_url] = kea_partners_d_path
  end

  def kea_partners_thanks
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

    # OverviewOpco.all.each do |opco|
    #   if opco['Builder_id'].nil?
    #     company = ClientCompany.new(name: client['Name'], client_company_type: 'OPCO', address: client['Address'], zipcode: client['Zipcode'], city: client['City'], auth_token: SecureRandom.hex(5).upcase)
    #   else
    #     company = ClientCompany.find(opco['Builder_id'])
    #     company.update(name: client['Name'], client_company_type: client['Type'], address: client['Address'], zipcode: client['Zipcode'], city: client['City'])
    #   end
    #   company.save
    # end

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
    OverviewCard.all.each do |card|
      if card['Export to Builder'] == 'To be exported'
        contact = OverviewContact.find(card['Customer Contact'].join)
        company = OverviewClient.find(contact['Company/School'].join)
        if card['Reference SEVEN'].present?
          training = Training.find_by(refid: card['Reference SEVEN'])
          training.update(title: card['Title'], vat: vat, unit_price: card['Unit Price'])
        else
          if contact['Builder_id'].nil?
            if company['Builder_id'].nil?
              new_company = ClientCompany.create(name: company['Name'], address: company['Address'], zipcode: company['Zipcode'], city: company['City'], client_company_type: company['Type'], description: '')
              company['Builder_id'] = new_company.id
              company.save
            end
            new_contact = ClientContact.new(name: contact['Name'], email: contact['Email'], client_company_id: new_company.id, title: '', role_description: '')
            new_contact.save
            contact['Builder_id'] = new_contact.id
            contact.save
          else
            new_contact = ClientContact.find(contact['Builder_id'])
          end
          company['Type'] == 'School' ? vat = false : vat = true
          training = Training.create(title: card['Title'], client_contact_id: new_contact.id, refid: "#{Time.current.strftime('%y')}-#{(Training.last.refid[-4..-1].to_i + 1).to_s.rjust(4, '0')}", satisfaction_survey: 'https://learn.byseven.co/survey', vat: vat, unit_price: card['Unit Price'])
          Session.create(title: 'Session 1', date: training.created_at, duration: 0, training_id: training.id)
        end
        card['Export to Builder'] = 'Exported'
        card['Reference SEVEN'] = training.refid
        card.save
      end
    end
    redirect_to trainings_path
  end

  # def export_airtable
  #   authorize @training
  #   existing_card = OverviewCard.all.select{|x| x['Reference SEVEN'] == @training.refid}&.first
  #   details = "Détail des sessions (date, horaires, intervenants):\n\n"
  #   to_date, to_staff, seveners = false, false, false
  #   @training.sessions.each do |session|
  #     if session.date.present?
  #       details += "- #{session.date.strftime('%d/%m/%Y')} de #{session.start_time.strftime('%Hh%M')} à #{session.end_time.strftime('%Hh%M')}"
  #       if session.session_trainers.present?
  #         details += " - #{(session.session_trainers.map{|x| x.initials}).join(', ')}\n"
  #       else
  #         details += " - A STAFFER\n"
  #         to_staff = true
  #       end
  #     else
  #       to_date = true
  #     end
  #     sevener = true if session.users.map{|x|x.access_level}.to_set.intersect?(['sevener+', 'sevener'].to_set)
  #   end
  #   if existing_card.present?
  #     existing_card['Due Date'] = @training.end_time.strftime('%Y-%m-%d') if @training.end_time.present?
  #     existing_card['Details'] = details
  #     if to_date
  #       existing_card['Status'] = 'En attente (dates) - ALL'
  #     elsif to_staff
  #       existing_card['Status'] = 'En attente (staff) - ALL'
  #     elsif sevener
  #       existing_card['Status'] = 'En attente réalisation (avec sevener)'
  #     else
  #       existing_card['Status'] = 'En attente réalisation (sans sevener)'
  #     end
  #     existing_card.save
  #   else
  #     card = OverviewCard.create("Title" => @training.title, "Reference SEVEN" => @training.refid, "VAT" => @training.vat, "Unit Price" => @training.unit_price, "Details" => details, 'Export to Builder' => 'Updated')
  #     card['Due Date'] = @training.end_time.strftime('%Y-%m-%d') if @training.end_time.present?
  #     raise
  #     contact = OverviewContact.all.select{|x| x['Name'] == @training.client_contact.name}
  #     client = OverviewClient.all.select{|x| x['Name'] == @training.client_contact.client_company.name}
  #     if contact.present?
  #       card['Customer Contact'] = contact.first
  #       card['Company/School'] = contact.first['Company/School']
  #     else
  #       builder_client = @training.client_contact.client_company
  #       unless client.present?
  #         new_client = OverviewClient.create('Name' => builder_client.name, 'Type' => builder_client.client_company_type, 'Address' => builder_client.address, 'Zipcode' => builder_client.zipcode, 'City' => builder_client.city, 'Builder_id' => builder_client.id)
  #         new_client.save
  #         new_contact = OverviewContact.create('Name' => @training.client_contact.name, 'Email' => @training.client_contact.email, 'Builder_id' => @training.client_contact.id, 'Company/School' => [new_client.id])
  #         new_contact.save
  #         card['Customer Contact'] = [new_contact.id]
  #       else
  #         new_contact = OverviewContact.create('Name' => @training.client_contact.name, 'Email' => @training.client_contact.email, 'Builder_id' => @training.client_contact.id, 'Company/School' => [client.first.id])
  #         card['Customer Contact'] = [new_contact.id]
  #       end
  #     end
  #     card.save
  #   end
  #   redirect_to training_path(@training)
  # end

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



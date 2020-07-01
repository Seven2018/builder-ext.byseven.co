class TrainingsController < ApplicationController
  before_action :set_training, only: [:show, :edit, :update, :update_survey, :destroy, :copy, :sevener_billing, :export_airtable]

  def index
    @sessions = Session.all
    # @session_trainer = SessionTrainer.new
    @form = Form.new
    # Index with 'search' option and global visibility for SEVEN Users
    if ['super admin', 'admin', 'project manager'].include?(current_user.access_level)
      if params[:search]
        if params[:search][:user]
          @trainings = policy_scope(Training)
          @trainings = ((Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:search][:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:search][:user]})).where("lower(trainings.title) LIKE ?", "%#{params[:search][:title].downcase}%")) + (Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:search][:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:search][:user]})).joins(client_contact: :client_company).where("lower(client_companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
          @user = User.find(params[:search][:user])
        else
          @trainings = policy_scope(Training)
          @trainings = ((Training.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%")) + (Training.joins(client_contact: :client_company).where("lower(client_companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
        end
      elsif params[:user]
        @trainings = policy_scope(Training)
        @trainings = Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:user]}))
        @user = User.find(params[:user])
      else
        @trainings = policy_scope(Training)
      end
    # Index for Sevener Users, with limited visibility
    else
      @trainings = policy_scope(Training).joins(sessions: :users).where("users.email LIKE ?", "#{current_user.email}")
    end
  end

  def index_completed
    if ['super admin', 'admin', 'project manager'].include?(current_user.access_level)
      if params[:search]
        if params[:search][:user]
          @trainings = ((Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:search][:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:search][:user]})).where("lower(trainings.title) LIKE ?", "%#{params[:search][:title].downcase}%")) + (Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:search][:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:search][:user]})).joins(client_contact: :client_company).where("lower(client_companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
          @user = User.find(params[:search][:user])
        else
          @trainings = ((Training.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%")) + (Training.joins(client_contact: :client_company).where("lower(client_companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
        end
      elsif params[:user]
        @trainings = Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(training_ownerships: {user_id: params[:user]}).or(Training.joins(:training_ownerships).joins(sessions: :session_trainers).where(session_trainers: {user_id: params[:user]}))
        @user = User.find(params[:user])
      else
        @trainings = Training.all
      end
    # Index for Sevener Users, with limited visibility
    else
      @trainings = Training.joins(sessions: :users).where("users.email LIKE ?", "#{current_user.email}")
      # @trainings = Training.joins(sessions: :session_trainers).where(session_trainers: {user_id: current_user.id})
    end
    authorize @trainings
    render partial: "index_completed"
  end

  # Index with weekly calendar view
  def index_week
    @trainings = Training.all
    @sessions = Session.all
    authorize @trainings
  end

  # Index with monthly calendar view
  def index_month
    @trainings = Training.all
    @sessions = Session.all
    authorize @trainings
  end

  def show
    authorize @training
    @training_ownership = TrainingOwnership.new
    @session = Session.new
    @users = User.all
  end

  def new
    @training = Training.new
    @training_ownership = TrainingOwnership.new
    @clients = ClientContact.all
    authorize @training
  end

  def create
    @training = Training.new(training_params)
    authorize @training
    @training.refid = "#{Time.current.strftime('%y')}-#{(Training.last.refid[-4..-1].to_i + 1).to_s.rjust(4, '0')}"
    @training.satisfaction_survey = 'https://learn.byseven.co/survey'
    # @training.title = ClientContact.find(params[:training][:client_contact_id]).client_company.name + ' - ' + params[:training][:title]
    if @training.save
      Session.create(title: 'Session 1', date: @training.created_at, duration: 0, training_id: @training.id)
      @training.export_airtable
      redirect_to training_path(@training)
    else
      render :new
    end
  end

  def edit
    authorize @training
  end

  def update
    authorize @training
    @training.update(training_params)
    if @training.save
      @training.export_airtable
      redirect_to training_path(@training)
    else
      render :edit
    end
  end

  def destroy
    authorize @training
    @training.destroy
    redirect_to trainings_path
  end

  def copy
    authorize @training
    @client_contact = ClientContact.find(params[:copy][:client_contact_id])
    @new_training = Training.new(@training.attributes.except("id", "created_at", "updated_at", "client_contact_id"))
    @new_training.title = params[:copy][:rename] if params[:copy][:rename].present?
    @new_training.refid = "#{Time.current.strftime('%y')}-#{(Training.last.refid[-4..-1].to_i + 1).to_s.rjust(4, '0')}"
    @new_training.client_contact_id = @client_contact.id
    if @new_training.save
      @training.sessions.each do |session|
        new_session = Session.create(session.attributes.except("id", "created_at", "updated_at", "training_id", "address", "room"))
        new_session.update(training_id: @new_training.id)
        session.workshops.each do |workshop|
          new_workshop = Workshop.create(workshop.attributes.except("id", "created_at", "updated_at", "session_id"))
          new_workshop.update(session_id: new_session.id)
          workshop.workshop_modules.each do |mod|
            new_mod = WorkshopModule.create(mod.attributes.except("id", "created_at", "updated_at", "workshop_id", "user_id"))
            new_mod.update(workshop_id: new_workshop.id)
          end
        end
      end
      redirect_to training_path(@new_training)
    else
      raise
    end
  end

  def sevener_billing
    authorize @training
    params[:filter].present? ? @user = User.find(params[:filter][:user]) : @user = current_user
  end

  def redirect_docusign
    skip_authorization
    redirect_to "https://account-d.docusign.com/oauth/auth?response_type=token&scope=signature&client_id=ce366c33-e8f1-4aa7-a8eb-a83fbffee4ca&redirect_uri=http://localhost:3000/docusign/callback"
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

  private

  def set_training
    @training = Training.find(params[:id])
  end

  def training_params
    params.require(:training).permit(:title, :client_contact_id, :mode, :satisfaction_survey, :unit_price, :vat)
  end
end

class AccessToken
  attr_reader :token
  def initialize(token)
    @token = token
  end

  def apply!(headers)
    headers['Authorization'] = "Bearer #{@token}"
  end
end

class InvoiceItemsController < ApplicationController
  before_action :set_invoice_item, only: [:show, :edit, :copy, :copy_here, :edit_client, :credit, :marked_as_send, :marked_as_paid, :marked_as_reminded, :destroy, :upload_sevener_invoice_to_drive]

  # Indexes with a filter option (see below)
  def index
    @invoice_items = policy_scope(InvoiceItem)
    index_filtered
    @invoice_items = InvoiceItem.where(created_at: params[:export][:start_date]..params[:export][:end_date]).order(:uuid) if params[:export].present?
    respond_to do |format|
      format.html
      format.csv { send_data @invoice_items.to_csv, filename: "Factures SEVEN #{params[:export][:start_date].split('-').join('')} - #{params[:export][:end_date].split('-').join('')}.csv" }
    end
  end

  # Shows an InvoiceItem in html or pdf version
  def show
    authorize @invoice_item
    if @invoice_item.invoice_lines.where(description: 'Nom').present?
      uuid = @invoice_item.uuid + ' - ' + @invoice_item.invoice_lines.where(description: 'Nom').first.comments.split('>')[1].split('<')[0]
    else
      uuid = @invoice_item.uuid
    end
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{uuid}",
          layout: 'pdf.html.erb',
          margin: { bottom: 45, top: 62 },
          header: { margin: { top: 0, bottom: 0 }, html: { template: 'invoice_items/header.pdf.erb' } },
          footer: { margin: { top: 0, bottom: 0 }, html: { template: 'invoice_items/footer.pdf.erb' } },
          template: 'invoice_items/show',
          background: true,
          show_as_html: params.key?('debug'),
          page_size: 'A4',
          encoding: 'utf8',
          dpi: 300,
          zoom: 1
        )
      end
    end
  end

  def edit
    authorize @invoice_item
  end

  def update
    authorize @invoice_item
    @invoice_item.update(invoiceitem_params)
    if @invoice_item.save
      redirect_to invoice_item_path(@invoice_item)
    end
  end

  # Creates a chart (Numbers) of InvoicesItems, for reporting purposes (gem)
  def report
    params[:date].present? ? @invoice_items = InvoiceItem.where(type: 'Invoice').where("created_at > ? AND created_at < ?", params[:date][:start_date], params[:date][:end_date]) : @invoice_items = InvoiceItem.where(type: 'Invoice').where("created_at > ? AND created_at < ?", Date.today.beginning_of_year, Date.today)
    # @invoice_items_grid = InvoiceItemsGrid.new(params[:invoice_items_grid])
    authorize @invoice_items
    respond_to do |format|
      format.html
      format.csv { send_data @invoice_items_grid.to_csv }
    end
  end

  # Creates a new InvoiceItem, proposing a pre-filled version to be edited if necessary
  def new_invoice_item
    @training = Training.find(params[:training_id])
    @client_company = ClientCompany.find(params[:client_company_id])
    @invoice = InvoiceItem.new(training_id: params[:training_id].to_i, client_company_id: params[:client_company_id].to_i, type: params[:type])
    authorize @invoice
    # attributes a invoice number to the InvoiceItem
    if params[:type] == 'Invoice'
      InvoiceItem.where(type: 'Invoice').count != 0 ? (@invoice.uuid = "FA#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Invoice').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')) : (@invoice.uuid = "FA#{Date.today.strftime('%Y')}00001")
    elsif params[:type] == 'Estimate'
      InvoiceItem.where(type: 'Estimate').count != 0 ? (@invoice.uuid = "DE#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Estimate').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')) : (@invoice.uuid = "DE#{Date.today.strftime('%Y')}00001")
    end
    @invoice.status = 'En attente'
      # @invoice.type == 'Invoice' ? @invoice.status = 'Non payée' : @invoice.status = 'En attente'
    # Fills the created InvoiceItem with InvoiceLines, according Training data
    if @training.client_contact.client_company.client_company_type == 'Company'
      product = Product.find(2)
      quantity = 0
      @training.sessions.each do |session|
        session.duration < 4 ? quantity += 0.5 * session.session_trainers.count : quantity += 1 * session.session_trainers.count
      end
      InvoiceLine.create(invoice_item: @invoice, description: @training.title, quantity: quantity, net_amount: product.price, tax_amount: product.tax, product_id: product.id, position: 1)
    else
      product = Product.find(1)
      quantity = 0
      @training.sessions.each do |session|
      quantity += session.duration
      end
      InvoiceLine.create(invoice_item: @invoice, description: @training.title, quantity: quantity, net_amount: product.price, tax_amount: product.tax, product_id: product.id, position: 1)
    end
    update_price(@invoice)
    if @invoice.save
      redirect_to invoice_item_path(@invoice)
    end
  end

  def new_airtable_invoice_item
    @training = Training.find(params[:training_id])
    airtable_training = OverviewCard.all.select{|x|x['Reference SEVEN'] == @training.refid}.first
    @client_company = ClientCompany.find(params[:client_company_id])
    @invoice = InvoiceItem.new(training_id: @training.id, client_company_id: @client_company.id, type: params[:type])
    skip_authorization
    # attributes a invoice number to the InvoiceItem
    if params[:type] == 'Invoice'
      InvoiceItem.where(type: 'Invoice').count != 0 ? (@invoice.uuid = "FA#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Invoice').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')) : (@invoice.uuid = "FA#{Date.today.strftime('%Y')}00001")
    elsif params[:type] == 'Estimate'
      InvoiceItem.where(type: 'Estimate').count != 0 ? (@invoice.uuid = "DE#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Estimate').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')) : (@invoice.uuid = "DE#{Date.today.strftime('%Y')}00001")
    end
    @invoice.status = 'En attente'
    # Fills the created InvoiceItem with InvoiceLines, according Training data
    @training.client_contact.client_company.client_company_type == 'Company' ? product = Product.find(2) : product = Product.find(1)
    line = InvoiceLine.new(invoice_item: @invoice, description: @training.title, quantity: airtable_training['Unit Number'], net_amount: airtable_training['Unit Price'], tax_amount: product.tax, product_id: product.id, position: 1)
    comments = "<br>Détail des séances (date, horaires, intervenant(s)) :<br><br>"
    @training.sessions.each do |session|
      lunch = session.workshops.find_by(title: 'Pause Déjeuner')
      if lunch.present?
        morning = session.workshops.where('position < ?', lunch.position)
        afternoon = session.workshops.where('position > ?', lunch.position)
        comments += "- Le #{session.date.strftime('%d/%m/%Y')} de #{session.start_time.strftime('%Hh%M')} à #{(session.start_time+morning.map(&:duration).sum.minutes).strftime('%Hh%M')} et de #{(session.end_time-afternoon.map(&:duration).sum.minutes).strftime('%Hh%M')} à #{session.end_time.strftime('%Hh%M')} : #{session.users.map{|x|x.fullname}.join(', ')}<br>" if session.date.present?
      else
        comments += "- Le #{session.date.strftime('%d/%m/%Y')} de #{session.start_time.strftime('%Hh%M')} à #{session.end_time.strftime('%Hh%M')} : #{session.users.map{|x|x.fullname}.join(', ')}<br>" if session.date.present?
      end
    end
    line.comments = comments
    line.save
    if airtable_training['Preparation'].present?
      preparation = Product.find(3)
      InvoiceLine.create(invoice_item: @invoice, description: 'Préparation formation', quantity: 1, net_amount: airtable_training['Preparation'], tax_amount: preparation.tax, product_id: preparation.id, position: 2)
    end
    update_price(@invoice)
    if @invoice.save
      redirect_to invoice_item_path(@invoice)
    end
  end

  def new_airtable_invoice_item_by_trainer
    skip_authorization
    @training = Training.find(params[:training_id])
    airtable_training = OverviewCard.all.select{|x|x['Reference SEVEN'] == @training.refid}.first
    @client_company = ClientCompany.find(params[:client_company_id])
    @training.trainers.each do |trainer|
      new_invoice = InvoiceItem.new(training_id: @training.id, client_company_id: @client_company.id, type: 'Invoice')
      InvoiceItem.where(type: 'Invoice').count != 0 ? (new_invoice.uuid = "FA#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Invoice').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')) : (new_invoice.uuid = "FA#{Date.today.strftime('%Y')}00001")
      comments = "<br>Intervenant(e) : #{trainer.fullname}<br><br>Détail des séances (date, horaires) :<br>"
      quantity = 0
      @training.sessions.joins(:session_trainers).where(session_trainers: {user_id: trainer.id}).each do |session|
        lunch = session.workshops.find_by(title: 'Pause Déjeuner')
        if lunch.present?
          morning = session.workshops.where('position < ?', lunch.position)
          afternoon = session.workshops.where('position > ?', lunch.position)
          comments += "- Le #{session.date.strftime('%d/%m/%Y')} de #{session.start_time.strftime('%Hh%M')} à #{(session.start_time+morning.map(&:duration).sum.minutes).strftime('%Hh%M')} et de #{(session.end_time-afternoon.map(&:duration).sum.minutes).strftime('%Hh%M')} à #{session.end_time.strftime('%Hh%M')}<br>" if session.date.present?
        else
          comments += "- Le #{session.date.strftime('%d/%m/%Y')} de #{session.start_time.strftime('%Hh%M')} à #{session.end_time.strftime('%Hh%M')}<br>" if session.date.present?
        end
        if airtable_training['Unit Type'] == 'Half day'
          session.workshops.find_by(title: 'Pause Déjeuner').present? ? quantity += 1 : quantity += 0.5
        elsif airtable_training['Unit Type'] == 'Hour'
          quantity += session.duration
        end
      end
      @training.client_contact.client_company.client_company_type == 'Company' ? product = Product.find(2) : product = Product.find(1)
      new_line = InvoiceLine.new(invoice_item: new_invoice, description: @training.title, quantity: quantity, net_amount: airtable_training['Unit Price'], tax_amount: product.tax, product_id: product.id, position: 1)
      new_line.comments = comments
      new_line.save
      new_invoice.save
      update_price(new_invoice)
    end
    redirect_to invoice_items_path(type: 'Invoice', training_id: @training.id)
  end

  def new_airtable_invoice_item_by_attendee
    skip_authorization
    @training = Training.find(params[:training_id])
    airtable_training = OverviewCard.all.select{|x|x['Reference SEVEN'] == @training.refid}.first
    if airtable_training['Unit Type'] == 'Participant'
      @client_company = ClientCompany.find(params[:client_company_id])
      @training.attendees.each do |attendee|
        new_invoice = InvoiceItem.new(training_id: @training.id, client_company_id: @client_company.id, type: 'Invoice')
        InvoiceItem.where(type: 'Invoice').count != 0 ? (new_invoice.uuid = "FA#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Invoice').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')) : (new_invoice.uuid = "FA#{Date.today.strftime('%Y')}00001")
        comments = "<br>Participant(e) : #{attendee.fullname}<br><br>Détail des séances (date, horaires) :<br>"
        @training.sessions.each do |session|
          if session.session_attendees.where(attendee_id: attendee.id).present?
            lunch = session.workshops.find_by(title: 'Pause Déjeuner')
            if lunch.present?
              morning = session.workshops.where('position < ?', lunch.position)
              afternoon = session.workshops.where('position > ?', lunch.position)
              comments += "- Le #{session.date.strftime('%d/%m/%Y')} de #{session.start_time.strftime('%Hh%M')} à #{(session.start_time+morning.map(&:duration).sum.minutes).strftime('%Hh%M')} et de #{(session.end_time-afternoon.map(&:duration).sum.minutes).strftime('%Hh%M')} à #{session.end_time.strftime('%Hh%M')}<br>" if session.date.present?
            else
              comments += "- Le #{session.date.strftime('%d/%m/%Y')} de #{session.start_time.strftime('%Hh%M')} à #{session.end_time.strftime('%Hh%M')}<br>" if session.date.present?
            end
          end
        end
        @training.client_contact.client_company.client_company_type == 'Company' ? product = Product.find(2) : product = Product.find(1)
        new_line = InvoiceLine.new(invoice_item: new_invoice, description: @training.title, quantity: 1, net_amount: airtable_training['Unit Price'], tax_amount: product.tax, product_id: product.id, position: 1)
        new_line.comments = comments
        new_line.save
        new_invoice.save
        update_price(new_invoice)
      end
    end
    redirect_to invoice_items_path(type: 'Invoice', training_id: @training.id)
    flash[:alert] = "This training unit type is not defined as 'Participant' in Airtable." unless airtable_training['Unit Type'] == 'Participant'
  end

  # Creates a new InvoiceItem (Sevener PoV), proposing a pre-filled version to be edited if necessary
  def new_sevener_invoice
    @training = Training.find(params[:training_id])
    params[:billing].present? ? sevener = current_user : sevener = User.find(params[:new_order][:user])
    @sevener_invoice = InvoiceItem.new(training_id: @training.id, client_company_id: @training.client_company.id, user_id: sevener.id, type: 'Order')
    authorize @sevener_invoice
    # Attributes a invoice number to the InvoiceItem
    InvoiceItem.where(type: 'Order').all.count != 0 ? (@sevener_invoice.uuid = "BC#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Order').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')) : (@sevener_invoice.uuid = "BC#{Date.today.strftime('%Y')}00001")
    @sevener_invoice.save
    if @training.client_contact.client_company.client_company_type == 'Entreprise'
      product = Product.find(10)
    else
      product = Product.find(11)
    end
    # Fills the created InvoiceItem with InvoiceLines, according Training data
    quantity = 0
    if params[:billing].present?
      unit_price = 0
      comments = "<p>D&eacute;tail des s&eacute;ances (date, horaires) :<br />\r\n"
      SessionTrainer.where(session_id: params[:billing][:sessions_ids][1..-1], user_id: sevener.id).each do |session_trainer|
        quantity += session_trainer.session.duration
        session_trainer.update(status: 'Order created', invoice_item_id: @sevener_invoice.id)
        unit_price = session_trainer.unit_price
        comments += "- le #{session_trainer.session.date.strftime('%d/%m/%Y')} - durée : #{session_trainer.session.duration}h<br />\r\n"
      end
      InvoiceLine.create(invoice_item: @sevener_invoice, description: @training.title, quantity: quantity, net_amount: unit_price, tax_amount: 0, product_id: product.id, position: 1, comments: comments)
    else
      SessionTrainer.where(session_id: @training.sessions.map(&:id), user_id: sevener.id).each do |session_trainer|
        quantity += session_trainer.session.duration
        session_trainer.update(status: 'Order created', invoice_item_id: @sevener_invoice.id)
        unit_price = session_trainer.unit_price
      end
      InvoiceLine.create(invoice_item: @sevener_invoice, description: @training.title, quantity: quantity, net_amount: product.price, tax_amount: 0, product_id: product.id, position: 1)
    end
    update_price(@sevener_invoice)
    redirect_to invoice_item_path(@sevener_invoice)
  end


  def new_estimate
    @client_company = ClientCompany.find(params[:client_company_id])
    @estimate = InvoiceItem.new(client_company_id: params[:client_company_id].to_i, type: 'Estimate')
    authorize @estimate
    Estimate.all.count != 0 ? (@estimate.uuid = "DE#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Estimate').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')) : (@estimate.uuid = "DE#{Date.today.strftime('%Y')}00001")
    if @estimate.save
      if @client_company.client_company_type == 'Company'
        product = Product.find(2)
        InvoiceLine.create(invoice_item: @estimate, description: product.name, quantity: 0, net_amount: product.price, tax_amount: product.tax, position: 1, product_id: 2)
      elsif @client_company.client_company_type == 'School'
        product = Product.find(1)
        quantity = 0
        InvoiceLine.create(invoice_item: @estimate, description: product.name, quantity: 0, net_amount: product.price, tax_amount: product.tax, position: 1, product_id: 1)
      end
      update_price(@estimate)
      redirect_to invoice_item_path(@estimate)
    end
  end

  # Allows the duplication of an InvoiceItem
  def copy
    authorize @invoice_item
    @training = Training.find(params[:copy][:training_id]) if params[:copy][:training_id].present?
    new_invoice_item = InvoiceItem.new(@invoice_item.attributes.except("id", "created_at", "updated_at", "training_id", "client_company_id", "status", "sending_date", "payment_date", "dunning_date"))
    if @invoice_item.type == 'Invoice'
      new_invoice_item.uuid = "FA#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Invoice').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')
    else
      new_invoice_item.uuid = "DE#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Estimate').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')
    end
    new_invoice_item.training_id = @training.id if @training.present?
    new_invoice_item.client_company_id = params[:copy][:client_company_id]
    new_invoice_item.status = 'En attente'
    if new_invoice_item.save
      @invoice_item.invoice_lines.each do |line|
        new_invoice_line = InvoiceLine.create(line.attributes.except("id", "created_at", "updated_at", "invoice_item_id"))
        new_invoice_line.update(invoice_item_id: new_invoice_item.id)
      end
      redirect_to invoice_item_path(new_invoice_item)
    else
      raise
    end
  end

  def copy_here
    authorize @invoice_item
    new_invoice_item = InvoiceItem.new(@invoice_item.attributes.except("id", "created_at", "updated_at", "sending_date", "payment_date", "dunning_date"))
    if @invoice_item.type == 'Invoice'
      new_invoice_item.uuid = "FA#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Invoice').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')
    else
      new_invoice_item.uuid = "DE#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Estimate').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')
    end
    new_invoice_item.status = 'En attente'
    if new_invoice_item.save
      @invoice_item.invoice_lines.each do |line|
        new_invoice_line = InvoiceLine.create(line.attributes.except("id", "created_at", "updated_at", "invoice_item_id"))
        new_invoice_line.update(invoice_item_id: new_invoice_item.id)
      end
      redirect_to invoice_item_path(new_invoice_item)
    else
      raise
    end
  end

  # Allows to change the ClientCompany of an InvoiceItem (OPCO cases)
  def edit_client
    authorize @invoice_item
    company = ClientCompany.find(params[:client_company_id])
    if company.client_company_type == 'Company'
      @invoice_item.update(client_company_id: company.opco_id, description: "#{company.id}")
    elsif company.client_company_type == 'OPCO'
      @invoice_item.update(client_company_id: @invoice_item.description.to_i, description: nil)
    end
    redirect_to invoice_item_path(@invoice_item)
  end

  # Creates a credit
  def credit
    authorize @invoice_item
    credit = InvoiceItem.new(@invoice_item.attributes.except("id", "created_at", "updated_at"))
    credit.uuid = "FA#{Date.today.strftime('%Y')}" + (InvoiceItem.where(type: 'Invoice').last.uuid[-5..-1].to_i + 1).to_s.rjust(5, '0')
    if credit.save
      @invoice_item.invoice_lines.each do |line|
        new_invoice_line = InvoiceLine.create(line.attributes.except("id", "created_at", "updated_at", "invoice_item_id"))
        new_invoice_line.update(invoice_item_id: credit.id)
        new_invoice_line.update(net_amount: -(line.net_amount)) if line.net_amount.present?
      end
      redirect_to invoice_item_path(credit)
    else
      raise
    end
  end

  def send_invoice_mail
    raise
  end

  # Marks an InvoiceItem as send
  def marked_as_send
    authorize @invoice_item
    index_filtered
    @invoice_item.update(sending_date: params[:edit_sending][:sending_date])
    redirect_back(fallback_location: invoice_item_path(@invoice_item))
  end

  # Marks an InvoiceItem as paid
  def marked_as_paid
    authorize @invoice_item
    index_filtered
    @invoice_item.update(payment_date: params[:edit_payment][:payment_date])
    respond_to do |format|
      format.html {redirect_to invoice_items_path(type: @invoice_item.type)}
      format.js
    end
  end

    # Marks an InvoiceItem as reminded
  def marked_as_reminded
    authorize @invoice_item
    index_filtered
    @invoice_item.update(dunning_date: params[:edit_payment][:dunning_date])
    respond_to do |format|
      format.html {redirect_to invoice_items_path(type: @invoice_item.type)}
      format.js
    end
  end

  # Uploads to a GoogleSheet (not used)
  def upload_to_sheet
    @invoice_items = InvoiceItem.where({ created_at: Time.current.beginning_of_year..Time.current.end_of_year }).order(:created_at)
    authorize @invoice_items
    # session = GoogleDrive::Session.from_service_account_key("client_secret.json")
    session = GoogleDrive::Session.from_config("client_secret.json")
    spreadsheet = session.spreadsheet_by_title("Copie de Seven Numbers #{Time.current.year}")
    worksheet = spreadsheet.worksheets.first
    row = 2
      @invoice_items.each do |item|
        startdate = item.training.sessions.order(date: :asc).first.date&.strftime('%d/%m/%y')
        enddate = item.training.sessions.order(date: :asc).last.date&.strftime('%d/%m/%y')
        client = item.client_company.name
        training_name = item.training.title
        trello = ''
        unit = 0
        unit_price = 0
        variable = 0
        fixed = 0
        caution = 0
        expenses = 0
        expenses_out = 0
        item.invoice_lines.each do |line|
          unit += line.quantity if ((line.product = Product.find(1) || line.product == Product.find(2) || line.product == Product.find(7) || line.product == Product.find(9)) && line.quantity.present?)
          unit_price += line.net_amount if ((line.product = Product.find(1) || line.product == Product.find(2)) && line.quantity.present? )
          variable += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present?)
          fixe += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present? && line.product.product_type == 'Préparation')
          caution += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present? && line.product.product_type == 'Caution')
          expenses += line.quantity * line.net_amount if (line.quantity.present? && line.net_amount.present? && line.product.product_type == 'Frais')
        end
        item.training.client_company.client_company_type == 'Company' ? nature = 'j' : nature = 'h'
        description = item.description
        vat = item.tax_amount
        revenue = item.total_amount
        num = item.uuid
        sending = item.sending_date&.strftime('%d/%m/%y') if item.sending_date.present?
        dunning = item.dunning_date&.strftime('%d/%m/%y') if item.dunning_date.present?
        payment = item.payment_date&.strftime('%d/%m/%y') if item.payment_date.present?
        worksheet.insert_rows(row, [[startdate, enddate, client, training_name, trello, unit, nature, unit_price, variable, fixed, caution, vat, expenses, expenses_out, description, revenue, num, sending, dunning, payment]])
        row += 1
        item.training.trainers.each do |trainer|
          if trainer.access_level == 'sevener'
            worksheet.insert_rows(row, [[startdate, enddate, client, training_name, trello, '0', '', '0', '', '', '', '', '', '', '', '0', '/', '/', '/', '/', '/', '/', "#{trainer.firstname} #{trainer.lastname}", '01/01/20', '','480', '01/01/20']])
            row += 1
          end
        end
      end
    # end
    # worksheet.delete_rows((Invoice.count+1), 1)
    worksheet.save
    redirect_back(fallback_location: root_path)
    flash[:notice] = "Uploadé avec succès"
  end

  def destroy
    authorize @invoice_item
    @invoice_item.destroy
    redirect_to client_company_path(@invoice_item.client_company)
  end

  def redirect_upload_to_drive
    skip_authorization
    client = Signet::OAuth2::Client.new(client_options)
    # Allows to pass informations through the Google Auth as a complex string
    client.update!(state: Base64.encode64(params[:invoice_item_id] + '|' + params[:file].tempfile))
    redirect_to client.authorization_uri.to_s
  end

  def upload_to_drive
    # @invoice_item = InvoiceItem.find(Base64.decode64(params[:state]).split('|').first)
    @invoice_item = InvoiceItem.find(params[:invoice_item_id])
    # file_path = Base64.decode64(params[:state]).split('|').last
    file_path = params[:file].tempfile
    authorize @invoice_item
    require 'google/apis/drive_v3'

    access_token = AccessToken.new 'SECRET_TOKEN'
    drive_service = Google::Apis::DriveV3::DriveService.new
    # client = Signet::OAuth2::Client.new(client_options)
    client = Signet::OAuth2::Client.new(client_options)
    drive_service.authorization = access_token

    # metadata = Drive::File.new(title: 'My document')
    # metadata = drive.insert_file(metadata, upload_source: 'test.txt', content_type: 'text/plain')
    file_metadata = {
      name: 'my_file_name.pdf',
      # parents: [folder_id],
      description: 'This is my file'
    }
    file = drive_service.create_file(file_metadata, upload_source: file_path, fields: 'id')
  end

  private

  # Filter for index method
  def index_filtered
    if params[:training_id].present?
      @invoice_items = InvoiceItem.where(training_id: params[:training_id].to_i)
    elsif params[:client_company_id].nil?
      @invoice_items = InvoiceItem.all.order('id DESC')
    elsif params[:type] == 'Invoice' && params[:client_company_id]
      @invoice_items = Invoice.where(client_company_id: params[:client_company_id].to_i).order('id DESC')
    elsif params[:type] == 'Estimate' && params[:client_company_id]
      @invoice_items = Estimate.where(client_company_id: params[:client_company_id].to_i).or(Estimate.where(description: params[:client_company_id])).order('id DESC')
    elsif params[:type] == 'Order'
      @invoice_items = InvoiceItem.where(training_id: params[:training_id], type: 'Order')
    end
  end

  # Updates InvoiceItem price and tax amount
  def update_price(invoice)
    total = 0
    tax = 0
    invoice.invoice_lines.each do |line|
      total += line.quantity * line.net_amount * (1 + line.tax_amount/100)
      tax += line.quantity * line.net_amount * (line.tax_amount/100)
    end
    invoice.update(total_amount: total, tax_amount: tax)
    invoice.save
  end

  def client_options
    {
      client_id: Rails.application.credentials.google_client_id,
      client_secret: Rails.application.credentials.google_client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::DriveV3::AUTH_DRIVE,
      redirect_uri: "#{request.base_url}/upload_to_drive"
    }
  end

  def set_invoice_item
    @invoice_item = InvoiceItem.find(params[:id])
  end

  def invoiceitem_params
    params.require(:invoice_item).permit(:status, :uuid)
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end
end


class ClientContactsController < ApplicationController
  before_action :set_clientcontact, only: [:show, :edit, :update, :destroy]

  def index
    @client_contacts = policy_scope(ClientContact).order(name: :asc)
  end

  def show
    authorize @client_contact
  end

  def new
    @client_contact = ClientContact.new
    @client_company = ClientCompany.find(params[:client_company_id])
    authorize @client_contact
  end

  def create
    @client_contact = ClientContact.new(clientcontact_params)
    @client_company = ClientCompany.find(params[:client_company_id])
    authorize @client_contact
    @client_contact.client_company = @client_company
    @client_contact.save ? (redirect_to client_company_client_contact_path(@client_company, @client_contact)) : (render :new)
  end

  def edit
    @companies = ClientCompany.all
    authorize @client_contact
  end

  def update
    @companies = ClientCompany.all
    authorize @client_contact
    @client_contact.update(clientcontact_params)
    @client_contact.save ? (redirect_to client_company_client_contact_path(@client_contact.client_company, @client_contact)) : (render "_edit")
  end

  def destroy
    @client_contact.destroy
    authorize @client_contact
    redirect_to client_company_path(@client_contact.client_company)
  end

  private

  def set_clientcontact
    @client_contact = ClientContact.find(params[:id])
  end

  def clientcontact_params
    params.require(:client_contact).permit(:name, :email, :title, :role_description, :client_company_id, :billing_contact, :billing_address, :billing_zipcode, :billing_city)
  end
end

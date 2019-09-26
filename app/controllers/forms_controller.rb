class FormsController < ApplicationController
  before_action :set_form, only: [:show, :edit, :update, :destroy]

  def index
    @forms = policy_scope(Form)
    @forms = Form.where(training_id: params[:training_id]) if params[:training_id]
  end

  def show
    authorize @form
  end

  private

  def set_form
    @form = Form.find(params[:id])
  end
end

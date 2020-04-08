class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :survey]

  def home
  end

  def survey
    redirect_to 'https://docs.google.com/forms/d/1knOYJWvoVV7T3IVCbNqoMtTbgMiDG6zroZSPrRJm5vY/edit'
  end

  def numbers_training
    params[:numbers_training].present? ? (@trainings = Training.numbers_scope(params[:numbers_training][:starts_at], params[:numbers_training][:ends_at])) : (@trainings = Training.numbers_scope)
  end
end

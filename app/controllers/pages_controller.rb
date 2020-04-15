class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :survey]

  def home
  end

  def overlord
  end

  def survey
    redirect_to 'https://docs.google.com/forms/d/1knOYJWvoVV7T3IVCbNqoMtTbgMiDG6zroZSPrRJm5vY/edit'
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
  end
end

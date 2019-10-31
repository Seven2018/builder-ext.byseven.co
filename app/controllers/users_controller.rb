class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    index_function(policy_scope(User))
  end

  def index_booklet
    index_function(User)
    authorize @users
  end

  def show
    if ['super admin', 'admin', 'training manager'].include?(current_user.access_level)
      @user = User.find(params[:id])
    elsif current_user.access_level == 'HR'
      @user = User.where(client_company_id: current_user.client_company_id).find(params[:id])
    else
      @user = current_user
    end
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    @user.update(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render "_edit"
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :access_level, :picture, :linkedin, :description, :rating, :client_company_id)
  end

  def index_function(parameter)
    if ['super admin', 'admin', 'training manager'].include? (current_user.access_level)
      if params[:search]
        @users = (parameter.where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + parameter.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
        @users = @users.sort_by{ |user| user.lastname } if @users.present?
      else
        @users = parameter.order('lastname ASC')
      end
    elsif current_user.access_level == 'HR'
      if params[:search]
        @users = (parameter.where(client_company_id: current_user.client_company.id).where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + parameter.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
        @users = @users.sort_by{ |user| user.lastname } if @users.present?
      else
        @users = parameter.where(client_company_id: current_user.client_company.id).order('lastname ASC')
      end
    end
  end
end

class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    index_function(policy_scope(User))
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    @user.access_level = 'user'
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
    if params[:search]
      @users = (parameter.where(access_level: 'user').where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + parameter.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
      @users = @users.sort_by{ |user| user.lastname } if @users.present?
    else
      @users = parameter.where(access_level: 'user').order(lastname: :asc)
    end
  end
end

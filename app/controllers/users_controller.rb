class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def index
    if params[:search]
      @users = (policy_scope(User).where('lower(firstname) LIKE ?', "%#{params[:search][:name].donwcase}%") + policy_scope(User).where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%")).order(:lastname)
    else
      @users = policy_scope(User).order(:lastname)
    end
  end

  def show
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
    @user.destroy
    authorize @user
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :access_level, :picture, :linkedin, :description, :rating)
  end
end

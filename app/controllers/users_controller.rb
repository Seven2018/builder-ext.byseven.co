class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    index_function(policy_scope(User))
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
    @user.picture = 'https://i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png' unless @user.picture.present?
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
    @user.update(picture: 'https://i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png') unless @user.picture.present?
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

  # Allows to scrape data from the current user Linkedin profile
  def linkedin_scrape
    skip_authorization
    oauth = LinkedIn::OAuth2.new
    url = oauth.auth_code_url
    redirect_to "#{url}"
  end

  def linkedin_scrape_callback
    skip_authorization
    oauth = LinkedIn::OAuth2.new
    code = params[:code]
    access_token = oauth.get_access_token(code)
    api = LinkedIn::API.new(access_token)
    client = RestClient
    # Updates User picture with his(her) Linkedin profile picture.
    url = 'https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))'
    res = RestClient.get(url, Authorization: "Bearer #{access_token.token}")
    picture_url = res.body.split('"').select{ |i| i[/https:\/\/media\.licdn\.com\/dms\/image\/.*/]}.last
    current_user.update(picture: picture_url)

    redirect_to user_path(current_user)
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

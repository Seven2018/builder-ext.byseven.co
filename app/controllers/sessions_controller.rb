class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy, :viewer]

  def index
    @training = Training.find(params[:training_id])
    @sessions = Session.where(training: @training)
    @sessions = policy_scope(Session).order(:date)
  end

  def show
    authorize @session
    @contents = Content.all
    @session_trainer = SessionTrainer.new
    @comment = Comment.new
    @themes = Theme.all
    # @contents.each do |content|
    #   @theme << content.theme
    # end
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@session.title}",
          layout: 'pdf.html.erb',
          template: 'sessions/show',
          # title: "#{@session.title}",
          show_as_html: params.key?('debug'),
          page_size: 'A4',
          encoding: 'utf8',
          dpi: 300,
          zoom: 1,
        )
      end
    end
  end

  def new
    @training = Training.find(params[:training_id])
    @session = Session.new
    authorize @session
  end

  def create
    @training = Training.find(params[:training_id])
    @session = Session.new(session_params)
    authorize @session
    @session.training = @training
    if @session.save
      SessionTrainer.create(session_id: @session.id, user_id: params[:session][:users].to_i)
      redirect_to training_path(@training)
    else
      render :new
    end
  end

  def edit
    @training = Training.find(params[:training_id])
    authorize @session
  end

  def update
    @training = Training.find(params[:training_id])
    authorize @session
    @session.update(session_params)
    if @session.save
      redirect_back(fallback_location: root_path)
    else
      render "_edit"
    end
  end

  def destroy
    @training = Training.find(params[:training_id])
    authorize @session
    @session.destroy
    redirect_to training_path(@training)
  end

  def viewer
    authorize @session
  end

  private

  def set_session
    @session = Session.find(params[:id])
  end

  def session_params
    params.require(:session).permit(:title, :date, :start_time, :end_time, :training_id, :duration, :attendee_number, :description, :teaser, { user_ids: [] }, session_trainers_attributes: [:id, :session_id, :user_id])
  end
end

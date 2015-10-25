# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.

require 'mandrill'
class UsersController < HelperController
  # Class is a controller for all Users.
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:edit, :update, :destroy]
  before_action :check_valid, only: [:edit, :update, :destroy]



  # GET /users/new
  def new
    @user = User.new
  end

  def edit
  end

  # POST /users

  def create

    #Ensure that the Date in parameters is in the correct format
    begin
      user_params["start_date"]=Date.parse(user_params["start_date"])
      user_params["end_date"]=Date.parse(user_params["end_date"])
    rescue ArgumentError
      # In scenario that date was not in correct format
      user_params["start_date"]=nil
      user_params["end_date"]=nil
    end
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to articles_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    # Ensure that the date in parameters is in correct format
    begin
      user_params["start_date"]=Date.parse(user_params["start_date"])
      user_params["end_date"]=Date.parse(user_params["end_date"])
    rescue ArgumentError
      # In scenario that the date was not in correct format
      user_params["start_date"]=nil
      user_params["end_date"]=nil
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to articles_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def scrape
    # Scrape internet for new articles between defined dates
    current_user.scrape_articles
    redirect_to articles_path, notice: "Articles successfully scraped"
  end
  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # log out and return to home page
    log_out @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to login_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def email
    #uses send_email from HelperController to send email
    sent = send_email current_user
    respond_to do |format|
      if not sent.nil?
        format.html { redirect_to articles_path, notice: 'successfully Emailed.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

  def check_valid
    # Checks that the current user is authenticated to view current page (i.e. ensuring user 1 doesnt edit user 2)
    unless @user==current_user
      render 'sessions/unauth', :status => 403


    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :bio, :username, :password, :password_confirmation, :interest_list, :start_date, :end_date)
    end
end

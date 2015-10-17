# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.


class SessionsController < ApplicationController

  # Before actions to check paramters
  before_action :check_params, only: [:login]
  before_action :authenticate_user, only: [:logout]

  def unauth

  end

  # Find a user with the username and email pair, log in that user if they exist
  def login
    # Find a user with params
    user = User.authenticate(@credentials[:password], @credentials[:email])
    if user
      # Save them in the session
      log_in user
      # Redirect to posts page
      redirect_to articles_path
  else
    redirect_to :back
  end
  end

  # Log out the user in the session and redirect to the unauth thing
  def logout
    log_out
    redirect_to login_path
  end

  # Private controller methods
  private
  def check_params
    params.require(:credentials).permit(:password, :email)
    @credentials = params[:credentials]
  end

end

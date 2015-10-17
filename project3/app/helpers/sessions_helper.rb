# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.

module SessionsHelper

  # Log a user in after authenticating, store in session
  def log_in user
    session[:user_id] = user.id
  end

  # Return the currently logged in user for this session
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) # initialises if not present
  end

  # Log out for a user
  def log_out
    session[:user_id] = nil
  end

end

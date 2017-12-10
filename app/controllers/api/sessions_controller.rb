# Handles incoming user account HTTP JSON web service requests
# @author Chris Loftus
class API::SessionsController < API::ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :login_required

  # POST /api/users.json
  def create
    respond_to do |format|
      format.json do
	 #checks the users login details, if the user doesn't exist or the credentials are incorrect it returns false
         user_detail = UserDetail.authenticate(params[:login], params[:password])
        if user_detail 
          render json: true
        else
          render json: false
        end
      end
    end
  end

end

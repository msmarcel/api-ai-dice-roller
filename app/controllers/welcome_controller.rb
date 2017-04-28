class WelcomeController < ApplicationController
skip_before_filter :verify_authenticity_token

  # GET /welcome
  def index
  end

  def rollit
    roll_service = RollService.new(params[:uid])
    roll_service.execute(params[:message])
    render json: { speech: roll_service.response_message, 
      displayText: roll_service.response_message  }
  end

end

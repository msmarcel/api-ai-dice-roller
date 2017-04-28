class WelcomeController < ApplicationController

  # GET /welcome
  def index
    roll_service = RollService.new(params[:uid])
    roll_service.execute(params[:message])
    render json: { speech: roll_service.response_message, 
      displayText: roll_service.response_message  }
  end

end

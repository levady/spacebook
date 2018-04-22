class ApplicationController < ActionController::API
  before_action :set_default_response_format

  def root
    render json: { message: "Nothing to see here, move along." }
  end

protected

  def set_default_response_format
    request.format = :json
  end
end

class ApplicationController < ActionController::API
  before_action :set_default_response_format
  before_action :validate_params

  def root
    render json: { message: "Nothing to see here, move along." }
  end

protected

  def set_default_response_format
    request.format = :json
  end

  def validate_params; end

  def render_error(object)
    render json: { success: false, errors: object.errors }
  end
end

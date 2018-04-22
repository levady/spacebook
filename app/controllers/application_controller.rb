class ApplicationController < ActionController::API
  before_action :set_default_response_format
  before_action :validate_params

  rescue_from ActiveRecord::RecordInvalid, :with => :render_error

  def root
    render json: { message: "Nothing to see here, move along." }
  end

protected

  def set_default_response_format
    request.format = :json
  end

  def validate_params; end

  def render_error(object)
    errors = object.is_a?(StandardError) ? object.record.errors : object.errors
    render json: { success: false, errors: errors }
  end
end

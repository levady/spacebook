class RelationshipsController < ApplicationController
  def index
    # TODO: Paginate the results.
    friends = Relationship.friends_of(@email_param.email).pluck(:target)
    render json: { success: true, friends: friends, count: friends.count }
  end

  def create
    Relationship.create_friendship!(@friends_param.requestor, @friends_param.target)
    render json: { success: true }
  end

private

  def validate_params
    case params[:action].to_sym
    when :create
      run_friends_param_validator
    when :index
      run_email_param_validator
    else
      # NO OP
    end
  end

  def run_friends_param_validator
    @friends_param = FriendsParamValidator.new(params[:friends])
    render_error(@friends_param) and return unless @friends_param.valid?
  end

  def run_email_param_validator
    @email_param = EmailParamValidator.new(params[:email])
    render_error(@email_param) and return unless @email_param.valid?
  end
end

class RelationshipsController < ApplicationController
  def create
    Relationship.create_friendship!(@friends_param.requestor, @friends_param.target)
    render json: { success: true }
  end

private

  def validate_params
    @friends_param = FriendsParamValidator.new(params[:friends])
    render_error(@friends_param) and return unless @friends_param.valid?
  end
end

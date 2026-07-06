class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ArgumentError, with: :render_unprocessable
  rescue_from ActionController::ParameterMissing, with: :render_unprocessable

  private

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_unprocessable(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end

class ApplicationController < ActionController::API
    include JwtToken
    include RideUtils

    before_action :authorize_request

    def not_found
        render json: { error: 'not_found' }
    end

    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
            @decoded = JwtToken.decode(header)
            @current_user = User.find(@decoded[:user_id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end

    def extract_user_id_from_token
        decoded_token = JwtToken.decode(request.headers['Authorization'].split(' ').last)
        decoded_token[:user_id]
    end
end

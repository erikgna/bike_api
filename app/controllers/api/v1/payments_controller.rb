module Api
    module V1
        class PaymentsController < ApplicationController
            before_action :authorize_request
            
            def index
                payments = Payment.order('created_at DESC');                
                render json: {status: 'SUCCESS', message: 'Loaded payments', data: payments}, status: :ok
            end

            def show
                payment = Payment.find(params[:id])
                render json: {status: 'SUCCESS', message: 'Loaded payment', data: payment}, status: :ok
            end

            def create
                user_id = extract_user_id_from_token
                payment = Payment.new(payment_params)
                payment.user_id = user_id
                if payment.save
                    render json: {status: 'SUCCESS', message: 'Saved payment', data: payment}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'payment not saved', data: payment.errors}, status: :unprocessable_entity
                end
            end

            def destroy
                payment = Payment.find(params[:id])
                payment.destroy
                render json: {status: 'SUCCESS', message: 'Deleted payment', data: payment}, status: :ok
            end

            def update
                payment = Payment.find(params[:id])
                if payment.update(payment_params)
                    render json: {status: 'SUCCESS', message: 'Updated payment', data: payment}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'payment not updated', data: payment.errors}, status: :unprocessable_entity
                end
            end

            def user_payments
                user_id = extract_user_id_from_token                
                user = User.find(user_id)
                payments = user.payments
                render json: { status: 'SUCCESS', message: 'User payments loaded', data: payments }, status: :ok
            end        

            private def payment_params
                params.permit(:card_number, :holder_name, :ccv, :expiration_date)
            end

            private def extract_user_id_from_token
                decoded_token = JwtToken.decode(request.headers['Authorization'].split(' ').last)
                decoded_token[:user_id]
            end
        end
    end
end
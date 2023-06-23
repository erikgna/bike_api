module Api
    module V1
        class PaymentsController < ApplicationController
            def index
                payments = Payment.order('created_at DESC');                
                render json: {status: 'SUCCESS', message: 'Loaded payments', data: payments}, status: :ok
            end

            def show
                payment = Payment.find(params[:id])
                render json: {status: 'SUCCESS', message: 'Loaded payment', data: payment}, status: :ok
            end

            def create
                payment = Payment.new(payment_params)
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
                user = User.find(params[:user_id])
                payments = user.payments
                render json: { status: 'SUCCESS', message: 'User payments loaded', data: payments }, status: :ok
            end        

            private def payment_params
                params.permit(:card_number, :holder_name, :ccv, :expiration_date)
            end
        end
    end
end
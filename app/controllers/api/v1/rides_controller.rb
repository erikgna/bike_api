module Api
    module V1
        class RidesController < ApplicationController
            before_action :authorize_request
            
            def show
                ride = Ride.find(params[:id])
                
                if !ride.payments_id.nil?
                    payment = Payment.find(ride.payments_id)
                    ride_data = ride.as_json(except: [:created_at, :updated_at, :user_id, :payments_id, :id]).merge(payment: payment.as_json(except: [:created_at, :updated_at, :user_id, :id]))
                else
                    ride_data = ride.as_json(except: [:created_at, :updated_at, :user_id, :payments_id, :id])
                end

                render json: {status: 'SUCCESS', message: 'Loaded ride', data: ride_data }, status: :ok
            end

            def user_rides
                user_id = extract_user_id_from_token                
                user = User.find(user_id)
                rides = user.rides.as_json(except: [:created_at, :updated_at, :user_id, :payments_id])
                render json: { status: 'SUCCESS', message: 'User rides loaded', data: rides }, status: :ok
            end

            def start_ride
                user_id = extract_user_id_from_token
                user = User.find(params[:user_id])
                payments = user.payments

                if payments.empty?
                    render json: { status: 'ERROR', message: 'No payment' }, status: :unprocessable_entity
                    return
                end
                
                ride = Ride.new(
                    creation_date: params[:creation_date],
                    city: params[:city],
                    start_date: params[:start_date],
                    start_location: params[:start_location],
                    user_id: user_id
                )
                
                if ride.save
                    render json: { status: 'SUCCESS', message: 'Ride started', data: ride }, status: :ok
                else
                    render json: { status: 'ERROR', message: 'Failed to start ride', data: ride.errors }, status: :unprocessable_entity
                end
            end

            def end_ride
                ride = Ride.find(params[:id])
                ride.end_date = params[:end_date]
                ride.end_location = params[:end_location]
                ride.path = params[:path]

                user_id = extract_user_id_from_token
                user = User.find(params[:user_id])
                payment = user.payments.first

                ride.payments_id = payment.id

                duration = calculate_duration(ride.start_date, ride.end_date)
                ride.value = calculate_value(duration)

                if ride.save
                    render json: { status: 'SUCCESS', message: 'Ride ended', data: ride }, status: :ok
                else
                    render json: { status: 'ERROR', message: 'Failed to end ride', data: ride.errors }, status: :unprocessable_entity
                end
            end

            private def ride_params
                params.permit(:value, :creation_date, :end_date, :city, :start_date, :start_location, :end_location, :path)
            end

            private def extract_user_id_from_token
                decoded_token = JwtToken.decode(request.headers['Authorization'].split(' ').last)
                decoded_token[:user_id]
            end
        end
    end
end
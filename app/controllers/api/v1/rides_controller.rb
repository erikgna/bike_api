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
                user = User.find(user_id)
                payments = user.payments

                if payments.empty?
                    render json: { status: 'ERROR', message: 'No payment' }, status: :unprocessable_entity
                    return
                end
                
                ride = Ride.new(                                        
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

                if ride.paid
                    render json: { status: 'SUCCESS', message: 'Ride paid', data: ride }, status: :ok
                    return
                end

                # Converter o JSON para uma lista de objetos de coordenadas
                coordinates = params[:path]
                total_distance = 0

                (0...coordinates.length - 1).each do |i|
                    start_coordinate = coordinates[i]
                    end_coordinate = coordinates[i + 1]

                    distance = calculate_distance(
                        start_coordinate['latitude'], start_coordinate['longitude'],
                        end_coordinate['latitude'], end_coordinate['longitude']
                    )

                    total_distance += distance
                end
                
                ride.end_date = params[:end_date]
                ride.end_location = params[:end_location]
                ride.path = params[:path]
                puts total_distance.round(2)
                ride.distance = total_distance.round(2)

                user_id = extract_user_id_from_token
                user = User.find(user_id)                            

                duration = calculate_duration(ride.start_date, ride.end_date)                
                ride.value = calculate_value(duration)

                if ride.save
                    render json: { status: 'SUCCESS', message: 'Ride ended', data: ride }, status: :ok
                else
                    render json: { status: 'ERROR', message: 'Failed to end ride', data: ride.errors }, status: :unprocessable_entity
                end
            end

            def pay_ride
                ride = Ride.find(pay_params[:ride_id])
                
                if ride.paid
                    render json: { status: 'SUCCESS', message: 'Ride paid', data: ride }, status: :ok
                    return
                end

                payment = Payment.find(pay_params[:payment_id])

                user_id = extract_user_id_from_token             
                ride.paid = true
                puts payment.card_number[-4..-1]
                ride.last_four_digits = payment.card_number[-4..-1]

                if ride.save
                    render json: { status: 'SUCCESS', message: 'Ride paid', data: ride }, status: :ok
                else
                    render json: { status: 'ERROR', message: 'Failed to pay ride', data: ride.errors }, status: :unprocessable_entity
                end
            end

            private def ride_params
                params.permit(:value, :end_date, :start_date, :start_location, :end_location, :path)
            end

            private def pay_params
                params.permit(:ride_id, :payment_id)
            end
        end
    end
end
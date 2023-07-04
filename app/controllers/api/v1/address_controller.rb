module Api
    module V1
        class AddressController < ApplicationController
            before_action :authorize_request
            
            def index
                addresses = Address.order('created_at DESC');                
                render json: {status: 'SUCCESS', message: 'Loaded addresses', data: addresses}, status: :ok
            end

            def show
                address = Address.find(params[:id])
                render json: {status: 'SUCCESS', message: 'Loaded address', data: address}, status: :ok
            end

            def create
                user_id = extract_user_id_from_token
                address = Address.new(address_params)
                address.user_id = user_id
                if address.save
                    render json: {status: 'SUCCESS', message: 'Saved address', data: address}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'address not saved', data: address.errors}, status: :unprocessable_entity
                end
            end

            def destroy
                address = Address.find(params[:id])
                address.destroy
                render json: {status: 'SUCCESS', message: 'Deleted address', data: address}, status: :ok
            end

            def update
                address = Address.find(params[:id])
                if address.update(address_params)
                    render json: {status: 'SUCCESS', message: 'Updated address', data: address}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'address not updated', data: address.errors}, status: :unprocessable_entity
                end
            end

            def user_addresses
                user_id = extract_user_id_from_token                
                user = User.find(user_id)
                addresses = user.addresses
                render json: { status: 'SUCCESS', message: 'User addresses loaded', data: addresses }, status: :ok
            end        

            private def address_params
                params.permit(:street, :number, :city, :state, :cep)
            end
        end
    end
end
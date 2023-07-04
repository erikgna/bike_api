module Api
    module V1
        class UsersController < ApplicationController
            before_action :authorize_request, except: [:create, :confirm_email]

            def index
                users = User.order('created_at DESC');                
                render json: {status: 'SUCCESS', message: 'Loaded users', data: users}, status: :ok
            end

            def show
                user = User.find(params[:id])
                render json: {status: 'SUCCESS', message: 'Loaded user', data: user}, status: :ok
            end

            def create
                user = User.new(user_params)
                if user.password == params[:password_confirmation]
                    user.password = BCrypt::Password.create(params[:password])
                else
                    render json: {status: 'ERROR', message: 'Passwords doesnt match'}, status: :unprocessable_entity
                    return
                end

                user.token = SecureRandom.urlsafe_base64 

                # UserMailerWorker.perform_async(user.id)
                UserMailer.confirmation_email(user).deliver_now
                if user.save
                    render json: {status: 'SUCCESS', message: 'Saved user', data: user}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'User not saved', data: user.errors}, status: :unprocessable_entity
                end
            end

            def confirm_email
                user = User.find_by(token: params[:token])
            
                if user
                  user.update(confirmed: true)
                  render json: { message: 'E-mail confirmado com sucesso!' }, status: :ok
                else
                  render json: { error: 'Token de confirmação inválido ou expirado.' }, status: :unprocessable_entity
                end
            end

            def destroy
                user = User.find(params[:id])
                user.destroy
                render json: {status: 'SUCCESS', message: 'Deleted user', data: user}, status: :ok
            end

            def update
                user = User.find(params[:id])
                if user.update(user_params)
                    render json: {status: 'SUCCESS', message: 'Updated user', data: user}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'User not updated', data: user.errors}, status: :unprocessable_entity
                end
            end

            private def user_params
                params.permit(:first_name, :last_name, :cpf, :email, :password).except(:password_confirmation)
            end
        end
    end
end
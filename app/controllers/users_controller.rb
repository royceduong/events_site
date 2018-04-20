class UsersController < ApplicationController
    def new
    end
    def create
        # u = User.new(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], location: params[:location], state: params[:state], password: params[:password], password_confirmation: params[:password_confirmation])
        u = User.new( user_params )
        if u.valid?
            u.save
            flash[:messages] = ["Registration Succesfull"]
        else
            flash[:messages] = u.errors.full_messages
        end
        redirect_to '/'
    end
    def login
        @u = User.find_by(email: params[:email])
        if @u && @u.authenticate(params[:password])
            session[:user_id] = @u.id
            redirect_to "/events"
        else
            flash[:messages] = ["Login Failed"]
            redirect_to "/"
        end
    end
    def edit
        @user = current_user
    end
    def update 
        @user = current_user
        if @user.update( user_params )
            flash[:messages] = ["User Updated"]
            redirect_to "/users/#{@user.id}/edit"
        else
            flash[:messages] = @user.errors.full_messages
            puts flash[:messages]
            redirect_to "/users/#{@user.id}/edit"
        end
    end
    private
        def user_params
            params.require(:user).permit(:first_name, :last_name, :email, :location, :state, :password, :password_confirmation)
        end
end

# test@user.com 
# 12345678

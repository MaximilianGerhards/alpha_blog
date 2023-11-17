class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        unless user.nil?
            if user.authenticate(params[:session][:password])
                session[:user_id] = user.id
                flash[:notice] = "Logged in successfully"
                redirect_to user
            else
                flash.now[:alert] = "Wrong email or password"
                render 'new'
            end
        else
            flash.now[:alert] = "This email is not yet registered"
            render 'new'
        end
    end

    def destroy
        session[:user_id] = nil
        flash[:notice] = "Logged out"
        redirect_to root_path
    end
end
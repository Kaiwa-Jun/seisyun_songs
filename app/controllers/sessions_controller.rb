class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "ログインに成功しました!"
      redirect_to root_path
    else
      flash.now[:error] = I18n.t('errors.messages.invalid_email_password')
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = I18n.t('messages.logged_out')
    redirect_to root_path
  end
end

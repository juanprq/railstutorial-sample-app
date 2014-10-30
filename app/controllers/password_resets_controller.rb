class PasswordResetsController < ApplicationController

  before_action :get_user, only: [:edit, :update]

  # Renderiza la página para pedir el correo y resetear la contraseña.
  def new
  end

  # Realiza el envio de correo para resetear la información.
  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email adress not found"
      render 'new'
    end
  end

  # Renderiza la página para cambiar la contraseña.
  def edit
  end

  # Realiza el reseteo de la contraseña por la ingresada el usuario en el formulario.
  def update
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired"
      redirect_to new_password_reset_url
    elsif @user.update_attributes(user_params)
      if(params[:user][:password].blank? && params[:user][:password_confirmation].blank?)
        flash.now[:danger] = "Password/confirmation can't be blank"
        render 'edit'
      else
        flash[:success] = "Password has been reset."
        log_in @user
        redirect_to @user
      end
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
      unless @user && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

end

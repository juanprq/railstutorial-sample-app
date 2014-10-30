class SessionsController < ApplicationController

  before_action :check_login, only: [:new, :create]

  # Prepara la plantilla para el formulario de log-in.
  def new
  end

  # Crea la sesión para que el ususario se identifique ante el sistema, log-in.
  def create
    # Se consulta el usuario por medio de su correo
    user = User.find_by email: params[:session][:email].downcase

    # Si el usuario se encontró y tiene el password correcto
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = "Account not activated. Check your emal for the activation link."
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  # Remueve el usuario en sessión y este pierde su autenticación.
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

    def check_login
      redirect_to current_user if logged_in?
    end

end

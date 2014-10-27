module SessionsHelper

  # Identifica un usuario en el sistema.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Recuerda el usuario logeado.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Olvida el usuario logeado
  def forget(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  # Retorna el usuario actual identificado en el sistema.
  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Indica si hay alguien identificado en el sistema.
  def logged_in?
    !current_user.nil?
  end

  # Elimina el identificador del usuario de la sesión.
  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

end
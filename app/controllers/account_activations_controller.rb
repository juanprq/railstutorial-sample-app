class AccountActivationsController < ApplicationController

  def edit
    # Se busca el usuario con el parámetro que viene en la url.
    user = User.find_by(email: params[:email])

    # Si encontró el usuario y este no se encuentra activado y el token es válido.
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = "Account activated!"
      log_in user
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

end

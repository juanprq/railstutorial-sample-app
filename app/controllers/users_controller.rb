class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :load_user, only: [:show, :edit]
  before_action :activated_user, only: :show

  # Carga y renderiza el listado de usuarios
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # Carga la pantalla de el usuario según el parámetro :id.
  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # Prepara la pantalla para crear un nuevo usuario.
  def new
    @user = User.new
  end

  # Crea un nuevo usuario en el sistema.
  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_mail
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to @user
    else
      render 'new'
    end
  end

  # Prepara la pantalla para actualizar la información de un usuario
  def edit
  end

  # Actualiza la información de un usuario.
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'User succesfully updated!'
      redirect_to @user
    else
      render 'edit'
    end
  end

  # Elimina un registro de usuario en el sistema.
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    # Strong params

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    #Before filters
    
    def correct_user
      redirect_to(root_url) unless params[:id].to_i == current_user.id
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def load_user
      @user = User.find(params[:id])
    end

    def activated_user
      redirect_to root_url and return unless @user.activated
    end

end

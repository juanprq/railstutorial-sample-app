require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  # Debería no crear el usuario debido a errores
  test 'User sign up should have errors' do
    # se para sobre la pantalla de registro
    get signup_path

    # Verifica que no hay diferencia en el contedo de usuarios antes y después de la ejecución de la operación
    assert_no_difference 'User.count' do
      post users_path, user: {name: "",
                              email: "user@invalid",
                              password: "foo",
                              password_confirmation: "bar"}
    end

    # Verifica que renderizó el template adecuado
    assert_template 'users/new'
  end

  test 'A new user should be created' do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path, user: {
        name: "Carlitos",
        email: "carlangas@hell.com",
        password: "foobar",
        password_confirmation: "foobar"
      }
    end
    # assert is_logged_in?
    # assert_template ''
  end

  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: {
        name: "Example user",
        email: "user@example.com",
        password: "foobar",
        password_confirmation: "foobar"
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Toma el valor de la variable users en el controlador de usuarios y la asigna a user
    # Como el usuario recién fue creado el valor del token de activación todavía está en este
    user = assigns(:user)
    # El usuario no debe estar activado
    assert_not user.activated?
    # El usuario no podrá logearse
    log_in_as user
    assert_not is_logged_in?
    # Token de activación incorrecto
    get edit_account_activation_path('invalid token')
    assert_not is_logged_in?
    # Token válido pero correo incorrecto
    get edit_account_activation_path(user.activation_token, email: 'bad email')
    assert_not is_logged_in?
    # Información válida
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end

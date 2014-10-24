require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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

    # assert_template ''
  end

end

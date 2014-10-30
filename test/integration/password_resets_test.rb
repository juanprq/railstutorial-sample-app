require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test 'password_reset' do
    get new_password_reset_path
    # Envio inválido
    post password_resets_path, password_reset: {email: "error"}
    assert_template 'password_resets/new'
    # Envio con información válida
    post password_resets_path, password_reset: {email: @user.email}
    assert_redirected_to root_url
    user = assigns(:user)
    follow_redirect!
    assert_select 'div.alert'
    assert_equal 1, ActionMailer::Base.deliveries.size
    
    # Se cambia la contraseña desde la pantalla de reseteo
    # Correo incorrecto
    get edit_password_reset_path(user.reset_token, email: 'wrong')
    assert_redirected_to root_url
    # Correo correcto, token incorrecto
    get edit_password_reset_path('wrong', email: user.email)
    assert_redirected_to root_url
    # Información correcta
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input#email[name=email][type=hidden][value=?]", user.email
    # Contraseñas con errores
    patch password_reset_path(user.reset_token), email: user.email, user: {
      password: '',
      password_confirmation: ''
    }
    assert_not_nil flash.now
    assert_template 'password_resets/edit'
    # Contraseñas válidas
    patch_via_redirect password_reset_path(user.reset_token), email: user.email, user: {
      password: 'foobaz',
      password_confirmation: 'foobaz'
    }
    assert_template 'users/show'
  end

  test 'expired token' do
    get new_password_reset_path
    post password_resets_path, password_reset: {email: @user.email}

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token), email: @user.email, user: {
      password: 'foobar',
      password_confirmation: 'foobar'
    }
    assert_response :redirect
    follow_redirect!
    assert_match 'Password reset has expired', response.body
  end

end

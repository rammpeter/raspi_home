require 'test_helper'

class KonfigurationControllerTest < ActionController::TestCase

  # Anmelden mit user/pw
  def authenticate
    konf = Konfiguration.get_aktuelle_konfiguration
    @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(konf.UserName, konf.Passwort)
  end


  test "show_konfiguration" do
    authenticate
    get :show_konfiguration
    assert_response :success
  end

  test "save_konfiguration" do
    authenticate
    post :save_konfiguration, :konfiguration => Konfiguration.get_initial_values_hash
    assert_response :redirect
  end

  test "show_historie" do
    authenticate
    Konfiguration.defaults do|key, value|
      get :show_historie, :column => key
      assert_response :success
    end
  end

end

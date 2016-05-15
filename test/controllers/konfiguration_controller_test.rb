require 'test_helper'

class KonfigurationControllerTest < ActionController::TestCase

  test "show_konfiguration" do
    get :show_konfiguration
    assert_response :success
  end

  test "save_konfiguration" do
    post :save_konfiguration, :konfiguration => Konfiguration.get_initial_values_hash
    assert_response :redirect
  end

  test "show_historie" do
    Konfiguration.defaults do|key, value|
      get :show_historie, :column => key
      assert_response :success
    end
  end

end

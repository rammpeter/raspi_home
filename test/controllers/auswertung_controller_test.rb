require 'test_helper'

class AuswertungControllerTest < ActionController::TestCase
  test "should get show_temperatur_verlauf" do
    get :show_temperatur_verlauf
    assert_response :success
  end

  test "list_temperatur_verlauf" do
    post :list_temperatur_verlauf
    assert_response :success
  end

end

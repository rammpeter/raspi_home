require 'test_helper'

class AuswertungControllerTest < ActionController::TestCase
  test "show_temperatur_verlauf" do
    get :show_temperatur_verlauf
    assert_response :success
  end

  test "show_temperatur_verlauf_aktuell" do
    post :show_temperatur_verlauf_aktuell
    assert_response :success
  end


  test "list_temperatur_verlauf" do
    post :list_temperatur_verlauf, params: {:start=>"12.05.2016", :ende=>"13.05.2016"}
    assert_response :success
  end

end

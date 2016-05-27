require 'test_helper'

class SchalterTypTest < ActiveSupport::TestCase
  setup do
  end

  test "all" do
    SchalterTyp.new('Dummy ohne Funktion', '0.0.0.0').get_schalter_status
    SchalterTyp.new('Dummy ohne Funktion', '0.0.0.0').set_schalter_status(0)
    SchalterTyp.new('Dummy ohne Funktion', '0.0.0.0').set_schalter_status(1)
  end


end

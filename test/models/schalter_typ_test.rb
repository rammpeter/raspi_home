require 'test_helper'

class SchalterTypTest < ActiveSupport::TestCase
  setup do
  end

  test "all" do
    SchalterTyp.new('Dummy ohne Funktion').get_schalter_status('0.0.0.0')
    SchalterTyp.new('Dummy ohne Funktion').set_schalter_status(0, '0.0.0.0')
    SchalterTyp.new('Dummy ohne Funktion').set_schalter_status(1, '0.0.0.0')
  end


end

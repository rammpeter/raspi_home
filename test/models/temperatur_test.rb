require 'test_helper'

class TemperaturTest < ActiveSupport::TestCase
  test "schreibe_temperatur" do
    Temperatur.schreibe_temperatur(18,20)
    sleep(1)
    Temperatur.schreibe_temperatur(19,21)

    assert Temperatur.find_each.count == 2
  end
end

require 'test_helper'

class TemperaturTest < ActiveSupport::TestCase
  setup do
    konf = Konfiguration.first
    konf.filename_vorlauf_sensor    = Rails.root.join('test', 'fixtures', 'vorlauf.sensor_file').to_s
    konf.filename_ruecklauf_sensor  = Rails.root.join('test', 'fixtures', 'ruecklauf.sensor_file').to_s
    konf.filename_sonne_sensor      = Rails.root.join('test', 'fixtures', 'sonne.sensor_file').to_s
    konf.filename_schatten_sensor   = Rails.root.join('test', 'fixtures', 'schatten.sensor_file').to_s
    konf.save

    #Temperatur.stubs(:get_schalter_status).returns(0)
    #Temperatur.stubs(:set_schalter_status)
  end

  teardown do
    #Temperatur.unstub(:get_schalter_status)
    #Temperatur.unstub(:set_schalter_status)

  end

  test "schreibe_temperatur" do
    start_count = Temperatur.count
    Temperatur.schreibe_temperatur
    sleep(1)
    Temperatur.schreibe_temperatur

    assert Temperatur.count == start_count + 2
  end

end

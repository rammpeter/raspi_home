require 'test_helper'

class TemperaturTest < ActiveSupport::TestCase
  setup do
    ENV['FILENAME_VORLAUF']   = Rails.root.join('test', 'fixtures', 'vorlauf.sensor_file').to_s
    ENV['FILENAME_RUECKLAUF'] = Rails.root.join('test', 'fixtures', 'ruecklauf.sensor_file').to_s
    ENV['FILENAME_SCHATTEN']  = Rails.root.join('test', 'fixtures', 'schatten.sensor_file').to_s
    ENV['FILENAME_SONNE']     = Rails.root.join('test', 'fixtures', 'sonne.sensor_file').to_s

    ENV['SCHALTER_TYP']       = 'Rutenbeck_TPIP1'
    ENV['SCHALTER_IP']        = '127.0.0.0'

    Temperatur.stubs(:get_schalter_status).returns(0)
    Temperatur.stubs(:set_schalter_status)
  end

  teardown do
    Temperatur.unstub(:get_schalter_status)
    Temperatur.unstub(:set_schalter_status)

  end

  test "schreibe_temperatur" do
    start_count = Temperatur.count
    Temperatur.schreibe_temperatur
    sleep(1)
    Temperatur.schreibe_temperatur

    assert Temperatur.count == start_count + 2
  end

end

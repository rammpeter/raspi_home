require 'test_helper'

class KonfigurationTest < ActiveSupport::TestCase
  setup do
  end

  teardown do
  end

  test "defaults" do
    assert Konfiguration.defaults.class == Hash
  end

  test 'get_initial_values_hash' do
    assert Konfiguration.get_initial_values_hash.class == Hash
  end

  test "get_title" do
    Konfiguration.defaults.each do |key, value|
      assert Konfiguration.get_title(key) == value[:title]
    end

  end

  test "ensure_first_record" do
    Konfiguration.delete_all
    Konfiguration.ensure_first_record
    konfiguration = Konfiguration.get_aktuelle_konfiguration

    Konfiguration.get_initial_values_hash.each do |key, value|
      assert konfiguration[key] == value                                        # Aktueller Record enthät Defaults
    end
  end

  test "get_aktuelle_konfiguration" do
    assert Konfiguration.get_aktuelle_konfiguration.class == Konfiguration
  end

end

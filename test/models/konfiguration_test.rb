require 'test_helper'

class KonfigurationTest < ActiveSupport::TestCase
  setup do
  end

  teardown do
  end

  test "ensure_first_record" do
    assert Konfiguration.ensure_first_record
  end
end

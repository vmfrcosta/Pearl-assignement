require "test_helper"

class VaultTest < ActiveSupport::TestCase
  test "it belongs to user" do
    assert_equal users(:one), vaults(:one).user
    assert_raise do
      vaults(:one).update! user: nil
    end
  end

  test "name is valid" do
    assert_raise do
      vaults(:one).update! name: nil
    end
  end
end

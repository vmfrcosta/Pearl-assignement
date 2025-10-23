require "test_helper"

class ApiKeyTest < ActiveSupport::TestCase
  test "it belongs to user" do
    assert_equal users(:one), api_keys(:one).user
    assert_raise do
      ApiKey.update! user: nil
    end
  end

  test "secret must be valid" do
    assert_raise do
      ApiKey.last.update! secret: ""
    end

    assert_raise do
      ApiKey.last.update! secret: ApiKey.first.secret
    end
  end

  test "shareable must be valid" do
    assert_raise do
      users(:one).private_key.update! shareable: true
    end
  end

  test "private?" do
    assert_equal true, api_keys(:one).private?
    assert_equal false, api_keys(:two).private?
  end

  test "shareable?" do
    assert_equal true, api_keys(:two).shareable?
    assert_equal false, api_keys(:one).shareable?
  end

  test "generate!" do
    users(:one).api_keys.destroy_all
    assert_difference "ApiKey.count", 2 do
      ApiKey.generate!(user: users(:one), shareable: true)
      ApiKey.generate!(user: users(:one), shareable: false)
    end
  end
end

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "name is valid" do
    assert_raise do
      users(:one).update! name: nil
    end
  end

  test "email is valid" do
    assert_raise do
      users(:one).update! email: nil
    end

    assert_raise do
      users(:one).update! email: "dsadsadas"
    end
  end

  test "api_keys are generated after user creation" do
    assert_difference "ApiKey.count", 2 do
      User.create! name: "test", email: "dsadsa@dsadsa.com"
      end
  end

  test "key methods" do
    assert users(:one).private_key.present?
    assert users(:one).shareable_key.present?
  end
end

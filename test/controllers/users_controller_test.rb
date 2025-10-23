require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end
  test "all users can be retrieved" do
    get users_path
    assert_response :success

    expected_response = Array.wrap(UserSerializer.new(@user).serializable_hash)
    assert_equal response.body, expected_response.to_json
  end

  test "users can be retrieved by email" do
    get users_path, params: { emails: @user.email }
    assert_response :success

    expected_response = Array.wrap(UserSerializer.new(@user).serializable_hash)
    assert_equal response.body, expected_response.to_json
  end

  test "no users are returned if there are no emails found" do
    get users_path, params: { emails: ["dsadsa", "vmfrcosta@gmail.com"] }
    assert_response :success

    expected_response = []

    assert_equal response.body, expected_response.to_json
  end

  test "user can be created" do
    post users_path, params: { user: { name: "test", email: "test@test.com" } }
    assert_response :success
    assert_equal 2, User.count

    expected_response = UserSerializer.new(User.last).serializable_hash
    assert_equal response.body, expected_response.to_json
  end

  test "user can be updated" do
    patch user_path(@user), headers: { "x-api-key": @user.private_key }, params: { user: { name: "test", email: "test@test.com" } }
    assert_response :success

    expected_response = UserSerializer.new(@user.reload).serializable_hash
    assert_equal response.body, expected_response.to_json
  end

  test "user can be deleted" do
    delete user_path(@user), headers: { "x-api-key": @user.private_key }
    assert_response :success
    assert_equal 0, User.count

    expected_response = { success: true }
    assert_equal response.body, expected_response.to_json
    end
end

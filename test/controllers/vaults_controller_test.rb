require "test_helper"

class VaultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vault = vaults(:one)
    @user = users(:one)
  end

  test "all vaults can be retrieved with a shareable_key" do
    get vaults_path, headers: { "x-api-key": @user.shareable_key }
    assert_response :success

    expected_response = Array.wrap(VaultSerializer.new(@vault).serializable_hash)

    assert_equal response.body, expected_response.to_json
  end

  test "vault can be created" do
    post vaults_path, headers: { "x-api-key": @user.private_key }, params: { vault: { name: "test" } }
    assert_response :success
    assert_equal 2, Vault.count

    expected_response = VaultSerializer.new(Vault.last).serializable_hash
    assert_equal response.body, expected_response.to_json
  end

  test "vault should not be created if api_key is not found" do
    post vaults_path, headers: { "x-api-key": "dsadsadsa" }, params: { vault: { name: "test" } }
    assert_response :unauthorized

    expected_response = {"error":"key not found"}.to_json
    assert_equal response.body, expected_response
  end

  test "vault should not be created if api_key is not private" do
    post vaults_path, headers: { "x-api-key": @user.shareable_key }, params: { vault: { name: "test" } }
    assert_response :unauthorized

    expected_response = {"error":"key must be private"}.to_json
    assert_equal response.body, expected_response
  end

  test "vault can be updated" do
    patch vault_path(@vault), headers: { "x-api-key": @user.private_key }, params: { vault: { name: "test" } }
    assert_response :success

    expected_response = VaultSerializer.new(@vault.reload).serializable_hash
    assert_equal response.body, expected_response.to_json
  end

  test "vault should not be updated if api_key is not found" do
    patch vault_path(@vault), headers: { "x-api-key": "dsadsadsa" }, params: { vault: { name: "test" } }
    assert_response :unauthorized

    expected_response = {"error":"key not found"}.to_json
    assert_equal response.body, expected_response
  end

  test "vault should not be updated if api_key is not private" do
    patch vault_path(@vault), headers: { "x-api-key": @user.shareable_key }, params: { vault: { name: "test" } }
    assert_response :unauthorized

    expected_response = {"error":"key must be private"}.to_json
    assert_equal response.body, expected_response
  end

  test "vault can be deleted" do
    delete vault_path(@vault), headers: { "x-api-key": @user.private_key }
    assert_response :success
    assert_equal 0, Vault.count

    expected_response = { success: true }
    assert_equal response.body, expected_response.to_json
  end

  test "vault should not be deleted if api_key is not found" do
    delete vault_path(@vault), headers: { "x-api-key": "dsadsadsa" }
    assert_response :unauthorized

    expected_response = {"error":"key not found"}.to_json
    assert_equal response.body, expected_response
  end

  test "vault should not be deleted if api_key is not private" do
    delete vault_path(@vault), headers: { "x-api-key": @user.shareable_key }
    assert_response :unauthorized

    expected_response = {"error":"key must be private"}.to_json
    assert_equal response.body, expected_response
  end
end

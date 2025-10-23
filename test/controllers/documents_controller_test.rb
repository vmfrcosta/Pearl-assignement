require "test_helper"

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @document = documents(:one)
    @vault = vaults(:one)
    @user = users(:one)
    @file = fixture_file_upload("document.pdf", "application/pdf")
  end

  test "document can be created" do
    post vault_documents_path(@vault), headers: { "x-api-key": @user.private_key }, params: { document: { name: "test", file: @file } }
    assert_response :success
    assert_equal 2, Document.count

    expected_response = DocumentSerializer.new(Document.last).serializable_hash
    assert_equal JSON.parse(response.body), JSON.parse(expected_response.to_json)
  end

  test "document can be created with file upload" do
    assert_difference 'Document.count' do
      post vault_documents_path(@vault), headers: { "x-api-key": @user.private_key }, params: { document: { name: "Uploaded Document", file: @file } }
    end

    assert_response :success

    document = Document.last
    assert_equal "Uploaded Document", document.name
    assert_not_nil document.file_url
    assert_not_nil document.metadata
    assert_equal "application/pdf", document.metadata["content_type"]
    assert_equal "document.pdf", document.metadata["original_filename"]
  end

  test "document should not be created without file" do
    post vault_documents_path(@vault), headers: { "x-api-key": @user.private_key }, params: { document: { name: "Test Document" } }

    assert_response :unprocessable_entity
    assert_includes JSON.parse(response.body)["errors"]["file"], "can't be blank"
  end

  test "document should not be created if api_key is not found" do
    post vault_documents_path(@vault), headers: { "x-api-key": "dsadsadsa" }, params: { document: { name: "test", file_url: "test.com" } }
    assert_response :unauthorized

    expected_response = {"error":"key not found"}.to_json
    assert_equal response.body, expected_response
  end

  test "document should not be created if api_key is not private" do
    post vault_documents_path(@vault), headers: { "x-api-key": @user.shareable_key }, params: { document: { name: "test", file: @file } }
    assert_response :unauthorized

    expected_response = {"error":"key must be private"}.to_json
    assert_equal response.body, expected_response
  end

  test "document can be updated" do
    patch vault_document_path(@vault, @document), headers: { "x-api-key": @user.private_key }, params: { document: { name: "t", file: @file } }
    assert_response :success
  end

  test "document can be updated with new file" do
    old_file_path = @document.file_url

    patch vault_document_path(@vault, @document), headers: { "x-api-key": @user.private_key }, params: { document: { name: "Document one", file: @file } }

    assert_response :success

    @document.reload
    assert_equal "Document one", @document.name
    assert_equal old_file_path, @document.file_url
    assert_equal "application/pdf", @document.metadata['content_type']
  end

  test "document should not be updated if api_key is not found" do
    patch vault_document_path(@vault, @document), headers: { "x-api-key": "dsadsadsa" }, params: { document: { name: "t", file_url: "t.com" } }
    assert_response :unauthorized

    expected_response = {"error":"key not found"}.to_json
    assert_equal response.body, expected_response
  end

  test "document should not be updated if api_key is not private" do
    patch vault_document_path(@vault, @document), headers: { "x-api-key": @user.shareable_key }, params: { document: { name: "t", file_url: "t.com" } }
    assert_response :unauthorized

    expected_response = {"error":"key must be private"}.to_json
    assert_equal response.body, expected_response
  end

  test "document can be deleted" do
    delete vault_document_path(@vault, @document), headers: { "x-api-key": @user.private_key }
    assert_response :success
    assert_equal 0, Document.count

    expected_response = { success: true }
    assert_equal response.body, expected_response.to_json
  end

  test "document should not be deleted if api_key is not found" do
    delete vault_document_path(@vault, @document), headers: { "x-api-key": "dsadsadsa" }
    assert_response :unauthorized

    expected_response = {"error":"key not found"}.to_json
    assert_equal response.body, expected_response
  end

  test "document should not be deleted if api_key is not private" do
    delete vault_document_path(@vault, @document), headers: { "x-api-key": @user.shareable_key }
    assert_response :unauthorized

    expected_response = {"error":"key must be private"}.to_json
    assert_equal response.body, expected_response
  end
end

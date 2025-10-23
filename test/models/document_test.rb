require "test_helper"

class DocumentTest < ActiveSupport::TestCase
  setup do
    @document = documents(:one)
    @vault = vaults(:one)
  end

  test "it belongs to vault" do
    assert_equal @vault, @document.vault
    assert_raise do
      @document.update! vault: nil
    end
  end

  test "name is valid" do
    assert_raise do
      @document.update! name: nil
    end
  end

  test "file_url is valid" do
    assert_raise do
      @document.update! file_url: nil
    end
  end

  test "metadata is valid" do
    assert_raise do
      @document.update! metadata: nil
      end
  end

  test "metadata can store file information" do
    metadata = {
    'file_size' => 1024,
    'content_type' => 'application/pdf',
    'original_filename' => 'test.pdf'
    }

    @document.update_column(:metadata,  metadata)
    @document.reload

    assert_equal 1024, @document.metadata['file_size']
    assert_equal 'application/pdf', @document.metadata['content_type']
    assert_equal 'test.pdf', @document.metadata['original_filename']
  end
end

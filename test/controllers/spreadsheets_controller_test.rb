require 'test_helper'

class SpreadsheetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get spreadsheets_index_url
    assert_response :success
  end

  test "should get new" do
    get spreadsheets_new_url
    assert_response :success
  end

  test "should get import" do
    get spreadsheets_import_url
    assert_response :success
  end

end

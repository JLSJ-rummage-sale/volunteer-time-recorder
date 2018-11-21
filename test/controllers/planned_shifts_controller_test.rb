require 'test_helper'

class PlannedShiftsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get planned_shifts_show_url
    assert_response :success
  end

  test "should get new" do
    get planned_shifts_new_url
    assert_response :success
  end

  test "should get index" do
    get planned_shifts_index_url
    assert_response :success
  end

  test "should get edit" do
    get planned_shifts_edit_url
    assert_response :success
  end

  test "should get delete" do
    get planned_shifts_delete_url
    assert_response :success
  end

end

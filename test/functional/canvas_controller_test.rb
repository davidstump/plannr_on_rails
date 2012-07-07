require 'test_helper'

class CanvasControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end

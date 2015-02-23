require 'test_helper'

class EnsemblesControllerTest < ActionController::TestCase
  test "should get choose" do
    get :choose
    assert_response :success
  end

end

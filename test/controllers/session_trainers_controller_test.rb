require 'test_helper'

class SessionTrainersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get session_trainers_new_url
    assert_response :success
  end

end

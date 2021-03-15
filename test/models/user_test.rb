require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'User valid' do
    user = User.new(firstname: 'Bob', lastname: 'Dylan', access_level: 'sevener', email: 'bob@dylan.fr', password: 'tititoto')
    assert user.valid?
  end
end

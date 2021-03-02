require 'test_helper'

class ActionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'action name validation' do
    action1 = Action.new(name: 'action', description: 'Ceci est une description')
    action2 = Action.new(name: 'action', description: 'Ceci est une autre description')
    action1.save
    assert action2.save, 'action2.name is not unique'
  end
end

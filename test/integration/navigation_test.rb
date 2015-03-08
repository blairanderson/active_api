require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    @routes = Engine.routes
  end

  def test_index
    get root_path
    assert(response.ok)
  end
end


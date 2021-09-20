require "test_helper"

class CustomControllerNameTest < ActionDispatch::IntegrationTest
  controller(ApplicationController, controller_name: "CustomsController") do
    def index
      render plain: self.class.name
    end
  end

  test "route matches controller name" do
    get "/customs"
    assert_equal(200, response.status)
  end

  test "controller name is correct" do
    get "/customs"
    assert_equal("CustomsController", response.body)
  end
end

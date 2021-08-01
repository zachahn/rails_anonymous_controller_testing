require "test_helper"

class CustomRoutesTest < ActionDispatch::IntegrationTest
  routes = proc do
    post "hello", to: "custom_routes_test/anonymous#hello"

    resources :earths, controller: "anonymous", module: "custom_routes_test"
  end

  controller(ApplicationController, routes: routes) do
    def hello
      render inline: "world"
    end

    def index
      render json: ["Earth", "Earth 2"]
    end
  end

  test "POST /hello" do
    post "/hello"
    assert_equal("world", response.body)
  end

  test "GET /earths" do
    get "/earths"
    assert_equal(["Earth", "Earth 2"].to_json, response.body)
  end
end

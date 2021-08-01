require "test_helper"

class InheritFromActionControllerBaseTest < ActionDispatch::IntegrationTest
  controller(ActionController::Base) do
    def index
    end
  end

  views["index.html.erb"] = <<~HTML
    <h1>Anonymous home page</h1>
  HTML

  test "GET anonymous index loads" do
    get "/anonymous"
    assert_response 200
    assert_equal self.class.views["index.html.erb"], response.body
    assert_select "h1", "Anonymous home page"
  end

  test "GET anonymous show doesn't load" do
    assert_raises(AbstractController::ActionNotFound) do
      get "/anonymous/1"
    end
  end
end

require "test_helper"

class FirstMultipleTestsInFileTest < ActionDispatch::IntegrationTest
  controller(ActionController::Base) do
    def index
    end
  end

  views["index.html.erb"] = <<~HTML
    <h1>First</h1>
  HTML

  test "GET anonymous index loads" do
    get "/anonymous"
    assert_select "h1", "First"
  end
end

class SecondMultipleTestsInFileTest < ActionDispatch::IntegrationTest
  controller(ActionController::Base) do
    def index
    end
  end

  views["index.html.erb"] = <<~HTML
    <h1>Second</h1>
  HTML

  test "GET anonymous index loads" do
    get "/anonymous"
    assert_select "h1", "Second"
  end
end

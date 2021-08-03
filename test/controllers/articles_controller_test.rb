require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "it loads" do
    get articles_path
    assert_select("span.author", 3)
    assert_includes(response.body, "@jack")
    assert_includes(response.body, "@biz")
    assert_includes(response.body, "@dom")
  end
end

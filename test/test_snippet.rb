require File.expand_path('../../lib/bakery', __FILE__)
require 'minitest/autorun'

class Bakery::TestSnippet < MiniTest::Unit::TestCase
  def setup
    @snippet = Bakery::Snippet.new("test")
  end

  def test_path
    assert_equal "snippets/test.html", @snippet.path
  end
end

require File.expand_path('../../lib/bakery', __FILE__)
require 'minitest/autorun'

class Bakery::TestPartial < MiniTest::Unit::TestCase
  def setup
    @snippet = Bakery::Partial.new("test.html")
  end

  def test_path
    assert_equal "templates/_test.html.erb", @snippet.path
  end
end

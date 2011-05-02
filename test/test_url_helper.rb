require File.expand_path('../../lib/bakery', __FILE__)
require File.expand_path('../bakery_config', __FILE__)
require 'minitest/autorun'

class Bakery::TestDataHelper < MiniTest::Unit::TestCase
  def setup
    @page = Bakery::Item.new("pages/test.html.md")
  end

  def test_url
    assert_equal "http://example.com/test.html", @page.context.url
  end

  def test_link
    assert "<a href=\"http://example.com/test.html\">Test</a>",
      @page.context.link("Test")
  end

  def test_link_ending_with_index_htm
    page = Bakery::Item.new("pages/index.htm.md")
    assert "<a href=\"http://example.com/\">Test</a>", page.context.link("Test")
  end

  def test_link_ending_with_index_html
    page = Bakery::Item.new("pages/index.html.md")
    assert "<a href=\"http://example.com/\">Test</a>", page.context.link("Test")
  end
  
  def test_link_with_options
    assert "<a href=\"http://example.com/test.html\" rel=\"nofollow\">Test</a>",
      @page.context.link("Test", :rel => "nofollow")
  end
end

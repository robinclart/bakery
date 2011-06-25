require File.expand_path('../../lib/bakery', __FILE__)
require File.expand_path('../bakery_config', __FILE__)
require File.expand_path('../page_mock', __FILE__)
require 'minitest/autorun'

class Bakery::TestPage < MiniTest::Unit::TestCase
  def setup
    @page = Bakery::Page.new("site/page.html.md")
    @post = Bakery::Page.new("site/post.html")
  end

  def test_path
    assert_equal "templates/page.html.erb", @page.template.path
  end

  def test_filename
    assert_equal "page.html", @page.template.filename
  end

  def test_from_model
    assert_equal "page.html", @page.template.from_model
    assert_equal "post.html", @post.template.from_model
  end

  def test_from_filename
    assert_equal "page.html", @page.template.from_filename
  end

  def test_from_data
    assert_equal "special.html", @page.template.from_data
  end

  def test_hypothetical_filenames
    assert_equal ["special.html", "page.html", "page.html"], @page.template.hypothetical_filenames
    assert_equal ["special.html", "post.html", "post.html"], @post.template.hypothetical_filenames
  end
end

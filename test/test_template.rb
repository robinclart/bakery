require File.expand_path('../../lib/bakery', __FILE__)
require File.expand_path('../bakery_config', __FILE__)
require File.expand_path('../item_mock', __FILE__)
require 'minitest/autorun'

class Bakery::TestItem < MiniTest::Unit::TestCase
  def setup
    @page = Bakery::Item.new("pages/test.html.md")
    @post = Bakery::Item.new("posts/test.html")
  end

  def test_path
    assert_equal "templates/index.html.erb", @page.template.path
  end

  def test_filename
    assert_equal "index.html", @page.template.filename
  end

  def test_from_model
    assert_equal "page.html", @page.template.from_model
    assert_equal "post.html", @post.template.from_model
  end

  def test_from_filename
    assert_equal "test.html", @page.template.from_filename
  end

  def test_from_data
    assert_equal "special.html", @page.template.from_data
  end

  def test_hypothetical_names
    assert_equal ["special.html", "test.html", "page.html"], @page.template.hypothetical_names
    assert_equal ["special.html", "test.html", "post.html"], @post.template.hypothetical_names
  end

  def test_from_filename_when_index
    assert_nil Bakery::Item.new("pages/index.htm").template.from_filename
    assert_nil Bakery::Item.new("pages/index.html").template.from_filename
    assert_nil Bakery::Item.new("pages/index.html.md").template.from_filename
  end
end

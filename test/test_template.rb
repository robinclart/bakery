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

  def test_basename
    assert_equal "index.html", @page.template.basename
  end

  def test_from_modelname
    assert_equal "page.html", @page.template.from_modelname
    assert_equal "post.html", @post.template.from_modelname
  end

  def test_from_basename
    assert_equal "test.html", @page.template.from_basename
  end

  def test_from_data
    assert_equal "special.html", @page.template.from_data
  end

  def test_from_basename_when_index
    assert_nil Bakery::Item.new("pages/index.htm").template.from_basename
    assert_nil Bakery::Item.new("pages/index.html").template.from_basename
    assert_nil Bakery::Item.new("pages/index.html.md").template.from_basename
  end

  def test_resolve_path
    assert_equal "templates/index.html.erb", @page.template.send(:resolve_path, "index.html")
  end
end

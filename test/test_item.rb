require File.expand_path('../../lib/bakery', __FILE__)
require File.expand_path('../bakery_config', __FILE__)
require File.expand_path('../item_mock', __FILE__)
require 'minitest/autorun'

class Bakery::TestItem < MiniTest::Unit::TestCase
  def setup
    @page = Bakery::Item.new("site/page.html.md")
    @post = Bakery::Item.new("site/post.html")
  end

  def test_filename
    assert_equal "page.html", @page.filename
  end

  def test_basename
    assert_equal "page", @page.basename
  end

  def test_extname
    assert_equal ".html", @page.extname
    assert_equal ".html", @post.extname
  end

  def test_model
    assert_equal "page", @page.model
  end

  def test_output_path
    assert_equal "public/page.html", @page.output.path
    assert_equal "public/blog/post/john-doe/2011/4/29/post.html", @post.output.path
  end

  def test_output_path_in_subdirectory
    page = Bakery::Item.new("site/sub/index.html.md")
    assert_equal "public/sub/index.html", page.output.path
  end

  def test_output_path_with_data_route
    page = Bakery::Item.new("site/data_path.html.md")
    assert_equal "public/special/path/index.html", page.output.path
  end

  def test_template
    assert_equal Bakery::Template, @page.template.class
  end

  def test_context
    assert_equal Bakery::Context, @page.context.class
    assert_equal @page, @page.context.item
  end

  def test_content
    content = "# Test\n\nHere comes some content\n"
    assert_equal content, @page.content
  end

  def test_data
    assert_equal "Test", @page.data.title
    assert_equal "special.html", @page.data.template
    assert_equal "29 April 2011", @page.data.published_at
    assert_equal "John Doe", @page.data.author
  end

  def test_if_item_need_markdown_processing
    assert @page.markdown?
    refute @post.markdown?
  end
end

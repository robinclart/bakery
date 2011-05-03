require File.expand_path('../../lib/bakery', __FILE__)
require File.expand_path('../bakery_config', __FILE__)
require File.expand_path('../item_mock', __FILE__)
require 'minitest/autorun'

class Bakery::TestItem < MiniTest::Unit::TestCase
  def setup
    @page = Bakery::Item.new("pages/test.html.md")
    @post = Bakery::Item.new("posts/test.html")
  end

  def test_filename
    assert_equal "test.html", @page.filename
  end

  def test_basename
    assert_equal "test", @page.basename
  end

  def test_extname
    assert_equal ".html", @page.extname
    assert_equal ".html", @post.extname
  end

  def test_model
    assert_equal "page", @page.model
  end

  def test_output_path
    assert_equal "public/test.html", @page.output_path
    assert_equal "public/blog/posts/john-doe/2011/4/29/test.html", @post.output_path
    assert_equal "public/articles/test/index.html", Bakery::Item.new("articles/test.html.md").output_path
  end

  def test_output_path_in_subdirectory
    page = Bakery::Item.new("pages/sub/test.html.md")
    assert_equal "public/sub/test.html", page.output_path
  end

  def test_output_path_with_data_path
    page = Bakery::Item.new("pages/test.html.md")
    def page.raw ; "---\npath: special/path/index\n---\n" ; end
    assert_equal "public/special/path/index.html", page.output_path
  end

  def test_template
    assert_equal Bakery::Template, @page.template.class
  end

  def test_context
    assert_equal Bakery::Context, @page.context.class
    assert_equal @page, @page.context.item
  end

  def test_base_directory
    assert_equal "pages", @page.base_directory
  end

  def test_sub_directory
    page = Bakery::Item.new("pages/sub/directory/test.html.md")
    assert_equal "sub/directory", page.sub_directory
  end

  def test_content
    content = "# Test\n\nHere comes some content"
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

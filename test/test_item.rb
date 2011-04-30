require File.expand_path('../../lib/bakery', __FILE__)
require File.expand_path('../bakery_config', __FILE__)
require File.expand_path('../item_mock', __FILE__)
require 'minitest/autorun'

class Bakery::TestItem < MiniTest::Unit::TestCase
  def setup
    @page = Bakery::Item.new("pages/test.html.md")
    @post = Bakery::Item.new("posts/test.html")
  end

  def test_basename
    assert_equal "test.html", @page.basename
  end

  def test_extname
    assert_equal ".html", @page.extname
    assert_equal ".html", @post.extname
  end

  def test_modelname
    assert_equal "page", @page.modelname
  end

  def test_output_path
    assert_equal "public/test.html", @page.output_path
    assert_equal "public/blog/posts/john-doe/2011/4/29/test.html", @post.output_path
  end

  def test_context
    assert_equal Bakery::Context, @page.context.class
    assert_equal @page, @page.context.item
  end

  def test_base_directory
    assert_equal "pages", @page.base_directory
  end

  def test_output_directory
    assert_equal "public", @page.output_directory
    assert_equal "public/blog/posts/john-doe/2011/4/29", @post.output_directory
  end

  def test_content
    content = "# Test\n\nHere comes some content"
    assert_equal "public/blog/posts/john-doe/2011/4/29", @post.output_directory
  end

  def test_data
    assert_equal "Test", @page.data.title
    assert_equal "special.html", @page.data.template
    assert_equal "29 April 2011", @page.data.published_at
    assert_equal "John Doe", @page.data.author
  end

  def test_if_item_need_markdown_processing
    assert @page.send(:markdown?)
    refute @post.send(:markdown?)
  end

  def test_template_path
    assert_equal "templates/index.html.erb", @page.template_path
  end

  def test_template_basename
    assert_equal "index.html", @page.template_basename
  end

  def test_base_template_name
    assert_equal "test.html", @page.send(:base_template_name)
  end

  def test_model_template_name
    assert_equal "page.html", @page.send(:model_template_name)
    assert_equal "post.html", @post.send(:model_template_name)
  end

  def test_base_template_name_when_index_html
    assert_nil Bakery::Item.new("pages/index.html.md").send(:base_template_name)
  end
end
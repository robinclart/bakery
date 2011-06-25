require File.expand_path('../../lib/bakery', __FILE__)
require File.expand_path('../bakery_config', __FILE__)
require File.expand_path('../page_mock', __FILE__)
require 'minitest/autorun'

class Bakery::TestPage < MiniTest::Unit::TestCase
  def setup
    @page = Bakery::Page.new("site/page.html.md")
    @post = Bakery::Page.new("site/post.html")
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

  def test_url
    assert_equal "http://example.com/page.html", @page.url
  end

  def test_url_ending_with_index_html
    page = Bakery::Page.new("site/index.html.md")
    assert_equal "http://example.com/", page.url
  end

  def test_url_ending_with_index_htm
    page = Bakery::Page.new("site/index.htm.md")
    assert_equal "http://example.com/", page.url
  end

  def test_model
    assert_equal "page", @page.model
  end

  def test_output_path
    assert_equal "public/page.html", @page.output.path
    assert_equal "public/blog/post/john-doe/2011/4/29/post.html", @post.output.path
  end

  def test_output_path_in_subdirectory
    page = Bakery::Page.new("site/sub/index.html.md")
    assert_equal "public/sub/index.html", page.output.path
  end

  def test_output_path_with_data_route
    page = Bakery::Page.new("site/data_path.html.md")
    assert_equal "public/special/path/index.html", page.output.path
  end

  def test_template
    assert_equal Bakery::Template, @page.template.class
  end

  def test_template_path
    assert_equal "templates/page.html.erb", @page.template.path
  end

  def test_template_filename
    assert_equal "page.html", @page.template.filename
  end

  def test_template_from_model
    assert_equal "page.html", @page.template.from_model
    assert_equal "post.html", @post.template.from_model
  end

  def test_template_from_filename
    assert_equal "page.html", @page.template.from_filename
  end

  def test_template_from_data
    assert_equal "special.html", @page.template.from_data
  end

  def test_template_hypothetical_filenames
    assert_equal ["special.html", "page.html", "page.html"], @page.template.hypothetical_filenames
    assert_equal ["special.html", "post.html", "post.html"], @post.template.hypothetical_filenames
  end

  def test_context
    assert_equal Bakery::Context, @page.context.class
    assert_equal @page, @page.context.page
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

  def test_if_page_need_markdown_processing
    assert @page.markdown?
    refute @post.markdown?
  end
end

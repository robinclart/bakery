require 'minitest/autorun'

begin
  require 'turn'
rescue LoadError
end

require File.expand_path('../../lib/bakery', __FILE__)

require "fileutils"
FileUtils.cd File.expand_path("../dummy", __FILE__)
load "Bakefile"

class Bakery::TestPage < MiniTest::Unit::TestCase
  def setup
    @home = Bakery::Page.new("site/index.html.md")
    @post = Bakery::Page.new("site/blog/hello-world.html.md")
  end

  def test_pathname
    assert_instance_of Pathname, @home.pathname
    assert_equal Pathname.new("site/index.html.md"), @home.pathname
    assert_equal Pathname.new("site/blog/hello-world.html.md"), @post.pathname
  end

  def test_path
    assert_equal "site/index.html.md", @home.path
    assert_equal "site/blog/hello-world.html.md", @post.path
  end

  def test_extname
    assert_equal ".html", @home.extname
  end

  def test_basename
    assert_equal "index", @home.basename
    assert_equal "hello-world", @post.basename
  end

  def test_filename
    assert_equal "index.html", @home.filename
    assert_equal "hello-world.html", @post.filename
  end

  def test_dirname
    assert_equal ".", @home.dirname
    assert_equal "blog", @post.dirname
  end

  def test_relative_path
    assert_equal "index.html", @home.relative_path
    assert_equal "blog/post/john-doe/2011/8/14/hello-world.html", @post.relative_path
  end

  def test_url
    assert_equal "http://example.com/", @home.url
    assert_equal "http://example.com/blog/post/john-doe/2011/8/14/hello-world.html", @post.url
  end

  def test_model
    assert_equal "page", @home.model
    assert_equal "post", @post.model
  end

  def test_if_markdown
    assert_instance_of TrueClass, @home.markdown?
  end

  def test_if_file_exist
    assert_instance_of TrueClass, @home.exist?
  end

  def test_template
    assert_instance_of Bakery::Template, @home.template
  end

  def test_template_path
    assert_equal "templates/home.html.erb", @home.template.path
    assert_equal "templates/post.html.erb", @post.template.path
  end

  def test_context
    assert_instance_of Bakery::Context, @home.context
  end

  def test_context_page
    assert_equal @home, @home.context.page
  end

  def test_template
    assert_instance_of Bakery::Template, @home.template
  end

  def test_template_pathname
    assert_instance_of Pathname, @home.template.pathname
    assert_equal Pathname.new("templates/home.html.erb"), @home.template.pathname
    assert_equal Pathname.new("templates/post.html.erb"), @post.template.pathname
  end

  def test_template_path
    assert_equal "templates/home.html.erb", @home.template.path
    assert_equal "templates/post.html.erb", @post.template.path
  end

  def test_if_template_exist
    assert_instance_of TrueClass, @home.template.exist?
    assert_instance_of TrueClass, @post.template.exist?
  end

  def test_output
    assert_instance_of Bakery::Output, @home.output
  end

  def test_output_pathname
    assert_instance_of Pathname, @home.output.pathname
    assert_equal Pathname.new("public/index.html"), @home.output.pathname
    assert_equal Pathname.new("public/blog/post/john-doe/2011/8/14/hello-world.html"), @post.output.pathname
  end

  def test_output_path
    assert_equal "public/index.html", @home.output.path
    assert_equal "public/blog/post/john-doe/2011/8/14/hello-world.html", @post.output.path
  end

  def test_if_output_exist
    assert_instance_of TrueClass, @home.output.exist?
    assert_instance_of TrueClass, @post.output.exist?
  end
end
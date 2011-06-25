require File.expand_path('../../lib/bakery', __FILE__)
require File.expand_path('../bakery_config', __FILE__)
require File.expand_path('../page_mock', __FILE__)
require 'minitest/autorun'

class Bakery::TestDataHelper < MiniTest::Unit::TestCase
  def setup
    @page = Bakery::Page.new("site/page.html.md")
  end

  def test_data
    assert_equal @page.data, @page.context.data
  end

  def test_data_helper_methods
    assert_equal @page.data.title, @page.context.title
    assert_equal @page.data.author, @page.context.author
    assert_nil @page.data.category
  end

  def test_published_at
    assert_equal Time, @page.context.published_at.class
    assert_equal Time.parse(@page.data.published_at), @page.context.published_at
  end
end

require "pathname"

module Bakery
  # == Template Lookup Procedure
  #
  # The template used by a page will be the first one to match an existing
  # file in the "templates/" directory:
  #
  # The lookup order is as follow:
  #
  # - A template that match the template name supplied in the data section
  #   of the page (1)
  # - A template with the same basename as the page (2)
  # - A template with the name of the page's model (3)
  # - The default template (4)
  #
  # For example a post with the following path "posts/hello-world.html.md"
  # will use:
  #
  # - "templates/supplied-template-name.html.erb" (1)
  # - "templates/hello-world.html.erb" (2)
  # - "templates/post.html.erb" (3)
  # - "templates/page.html.erb" (4)
  #
  # Note that the extension (without the ".md" for the pages and without the
  # ".erb" for a templates) should be the same to match. So if you are using
  # ".htm" instead of ".html" in your file name your template basename should
  # reflect this difference.
  class Template
    def initialize(filename)
      @filename = filename
    end

    class << self
      def resolve_pathname(filename) #:nodoc:
        DIRECTORY.join("#{filename}.erb")
      end

      def resolve_partial_pathname(filename)
        resolve_pathname("_#{filename}")
      end
    end

    DIRECTORY = Pathname.new("templates")

    BLANK_TEMPLATE = "<%= yield %>"

    attr_reader :filename

    def pathname
      @pathname ||= @filename ? self.class.resolve_pathname(filename) : nil
    end

    # Returns the template path for the current page.
    def path
      @path ||= @filename ? pathname.to_s : nil
    end

    # Returns the content of the page's template.
    def content
      @content ||= @filename ? pathname.read : BLANK_TEMPLATE
    end

    def exist?
      !!@filename
    end
  end
end
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
    def initialize(page, fallback = "page")
      @fallback      = [fallback, page.extname].join
      @from_model    = [page.model, page.extname].join
      @from_filename = page.filename
      @from_data     = page.data.template
    end

    ERROR = Pathname.new("../templates/error.html.erb").expand_path(__FILE__)

    DIRECTORY = Pathname.new("templates")

    attr_reader :fallback

    attr_reader :from_model

    attr_reader :from_filename

    attr_reader :from_data

    def pathname
      @pathname ||= Pathname.new(resolve_path(filename))
    end

    # Returns the template path for the current page.
    def path
      pathname.to_s
    end

    # Returns the content of the page's template.
    def content
      @content ||= pathname.read
    end

    # Returns the basename of the page's template (without the ".erb"
    # extension).
    def filename
      available_filenames.first or fallback
    end

    # Returns an array of all the availables template names (without the
    # ".erb" extension) for the current page.
    def available_filenames
      hypothetical_filenames.select { |name| File.exists? resolve_path(name) }
    end

    # Returns an array of all the suitable template names (without the ".erb"
    # extension) for the current page.
    def hypothetical_filenames
      [from_data, from_filename, from_model].compact
    end

    private

    def resolve_path(name) #:nodoc:
      DIRECTORY.join("#{name}.erb").to_s
    end
  end
end

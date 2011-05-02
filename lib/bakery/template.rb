module Bakery
  # == Template Lookup Procedure
  #
  # The template used by an item will be the first one to match an existing
  # file in the "templates/" directory:
  #
  # The lookup order is as follow:
  #
  # - A template that match the template name supplied in the data section
  #   of the item (1)
  # - A template with the same basename as the item (2)
  # - A template with the name of the item's model (3)
  # - The index template file (4)
  #
  # For example a post with the following path "posts/hello-world.html.md"
  # will use:
  #
  # - "templates/supplied-template-name.html.erb" (1)
  # - "templates/hello-world.html.erb" (2)
  # - "templates/post.html.erb" (3)
  # - "templates/index.html.erb" (4)
  #
  # Note that the extension (without the ".md" for the items and without the
  # ".erb" for a templates) should be the same to match. So if you are using
  # ".htm" instead of ".html" in your file name your template basename should
  # reflect this difference.
  #
  # Also be noted that all items starting with "index.*" won't resolve at (2)
  # but at (4) in order to allow those items to be compiled into the
  # template with the name of the item's model
  class Template
    def initialize(item, fallback = "index")
      @fallback      = [fallback, item.extname].join
      @from_model    = [item.model, item.extname].join
      @from_filename = item.filename unless item.filename == @fallback
      @from_data     = item.data.template
      @path          = Pathname.new(resolve_path(filename))
    end

    ERROR = Pathname.new("../templates/error.html.erb").expand_path(__FILE__)
    DIRECTORY = Pathname.new("templates")

    attr_reader :fallback, :from_model, :from_filename, :from_data

    # Returns the content of the item's template.
    def content
      @content ||= @path.read
    end

    # Returns the template path for the current item.
    def path
      @path.to_s
    end

    # Returns the basename of the item's template (without the ".erb"
    # extension).
    def filename
      available_filenames.first or fallback
    end

    # Returns an array of all the availables template names (without the
    # ".erb" extension) for the current item except the fallback one.
    def available_filenames
      hypothetical_filenames.select { |name| File.exists? resolve_path(name) }
    end

    # Returns an array of all the suitable template names (without the ".erb"
    # extension) for the current item except the fallback one.
    def hypothetical_filenames
      [from_data, from_filename, from_model].compact
    end

    private

    def resolve_path(name) #:nodoc:
      File.join(DIRECTORY, "#{name}.erb")
    end
  end
end

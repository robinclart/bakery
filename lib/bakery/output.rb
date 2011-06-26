module Bakery
  class Output
    def initialize(page)
      @pathname = DIRECTORY.join(page.relative_path).cleanpath
      @error = false
    end

    DIRECTORY = Pathname.new("public")

    attr_reader :pathname

    attr_writer :content

    attr_accessor :error

    # Returns the output path of a page.
    #
    # By default the pages from the "page" model will be rendered at
    # the root of the public directory. All the other models that you have
    # supplied in your Bakefile will be rendered in ":base/:sub/:name"
    #
    # If the output path have been overwritten in the Bakefile the path
    # will be interpolated and every keywords found (a string beginning by a
    # colon) found will be:
    #
    # - replaced by the value of the directory (for the :dirname keywords).
    # - replaced by the value of the filename (for the :filename keywords).
    # - replaced by the value of the day, month, year of the published_at
    #   field if it is present in the YAML Front Matter (for the :day, :month
    #   and :year keywords).
    # - replaced by the value of the same keyword in the YAML Front Matter.
    # - removed if none of the previous conditions were fulfilled.
    #
    # Example of interpolation configuration one can found in a Bakefile:
    #
    #   route post: ":dirname/:author/:year/:month/:day/:filename"
    #
    # This will give: "public/posts/john-doe/2011/4/29/hello-world.html".
    #
    # or for this:
    #
    #   route post: ":dirname/:author/:year/:month/:day/:filename/index"
    #
    # This will give: "public/posts/john-doe/2011/4/29/hello-world/index.html".
    #
    # Note that the extension are automatically appended to the path.
    def path
      @pathname.to_s
    end

    def content
      @content ||= @pathname.read
    end
    alias :to_s :content

    def full_error_message
      "#{error.class.name}: #{error.message}"
    end

    def error?
      !!@error
    end

    def options_for_create_file
      error? ? { force: true, verbose: false } : {}
    end
  end
end

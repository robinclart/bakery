require "pathname"

module Bakery
  # == Output path resolving
  #
  # By default all the pages will be rendered in "public/:dirname/:filename"
  #
  # If the output path have been overwritten in the Bakefile or in the file data
  # the path will be interpolated and every keywords found (a string beginning
  # by a colon) found will be:
  #
  # - replaced by the value of the directory (for the :dirname keywords).
  # - replaced by the value of the filename (for the :filename keywords).
  # - replaced by the value of the day, month, year of the published_at
  #   field if it is present in the file data (for the :day, :month and :year
  # keywords).
  # - replaced by the value of the same keyword in the file data.
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
  # Note that the extension is automatically appended.
  class Output
    def initialize(relative_path, content)
      @pathname = self.class.resolve_pathname(relative_path)
      @content = content
    end

    class << self
      def resolve_pathname(relative_path) #:nodoc:
        DIRECTORY.join(relative_path).cleanpath
      end
    end

    DIRECTORY = Pathname.new("public")

    attr_reader :pathname

    attr_reader :content
    alias :to_s :content

    # Returns the output path of a page.
    def path
      @pathname.to_s
    end

    def exist?
      @pathname.exist?
    end
  end
end
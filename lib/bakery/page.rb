require "pathname"
require "date"
require "time"
require "yaml"
require "ostruct"
require "active_support/inflector"

module Bakery
  class Page
    def initialize(path)
      @pathname = Pathname.new(path).cleanpath
      @dirname = @pathname.relative_path_from(DIRECTORY).dirname
      @filename = @pathname.basename(".md")
      @extname = @filename.extname
      @basename = @filename.basename(@extname).to_s
    end

    class << self
      def to_a
        Dir[DIRECTORY.join("**", "*.*").to_s].map { |p| self.new(p) }
      end
      alias :all :to_a

      def where(conditions = {})
        all.select do |page|
          conditions.all? { |k,v| page.data.send(k) == v }
        end
      end
    end

    DIRECTORY = Pathname.new("site")

    DEFAULT_ROUTE = ":dirname/:filename"

    attr_reader :pathname

    attr_reader :extname

    attr_reader :basename

    def path
      @pathname.to_s
    end

    def exist?
      @pathname.exist?
    end

    def relative_path
      @relative_path ||= Pathname.new(interpolate_route + extname).cleanpath.to_s
    end

    def url
      @url ||= Routing.root + relative_path.sub(/index.htm[l]?$/, "")
    end

    def model
      @model ||= data.model || "page"
    end

    # Returns the filename of the page without the ".md" if it's present.
    def filename
      @filename.to_s
    end

    def dirname
      @dirname.to_s
    end

    def content
      extract_content_and_yaml unless defined?(@content)
      @content
    end

    def yaml
      extract_content_and_yaml unless defined?(@yaml)
      @yaml
    end

    def output
      @output ||= Output.new(relative_path, render)
    end

    # Returns an instance of Template that holds all the information about the
    # template for the current page.
    def template
      @template ||= Template.new(template_filename)
    end

    # Returns a Context instance tied to the current page. All pages will be
    # rendered through this context.
    def context
      @context ||= Context.new(self)
    end

    # Returns all the content under the YAML Front Matter in HTML format.
    # Depending if the file path ends with ".md" or not the content will be
    # processed through <tt>Redcarpet</tt> or not.
    def to_html
      @html ||= markdown? ? context.markdown(content) : content
    end

    # Returns a freezed OpenStruct loaded with all the data present in the
    # YAML Front Matter.
    def data
      @data ||= OpenStruct.new(YAML.load(yaml.to_s))
    end

    def [](key)
      data.send(key)
    end

    def interpolate_route
      @interpolated_route ||= route.gsub(/:[a-z_]+/) do |chunk|
        case chunk.gsub!(":", "")
        when "dirname"          then dirname
        when "filename"         then basename
        when /^day|month|year$/ then published_at(chunk)
        else interpolate_chunk(chunk)
        end
      end
    end

    def published_at(meth = nil)
      if data.published_at
        date = Date.parse(data.published_at)
        meth ? date.send(meth).to_s : date
      end
    end

    def markdown?
      @pathname.extname == ".md"
    end

    private

    def extract_content_and_yaml
      @content, @yaml = @pathname.read.split("\n+++\n").reverse
    end

    # Render the page into its template.
    def render
      context.render(template.content) { to_html }
    end

    def route
      @route ||= data.route || Routing.routes.fetch(model.intern, DEFAULT_ROUTE)
    end

    def interpolate_chunk(chunk)
      data.send(chunk).parameterize if data.send(chunk)
    end

    def template_filename
      filenames = [data.template, basename, model, "page"]
        .compact.reverse.uniq.map { |f| [f, extname].join }
        .select { |f| Template.resolve_pathname(f).exist? }
      filenames.empty? ? nil : filenames.last
    end
  end
end
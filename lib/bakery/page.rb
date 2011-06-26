module Bakery
  class Page
    def initialize(path)
      @pathname       = Pathname.new(path).cleanpath
      @dirname        = @pathname.relative_path_from(DIRECTORY).dirname
      @filename       = @pathname.basename(".md")
      @extname        = @filename.extname
      @basename       = @filename.basename(@extname).to_s
    end

    class << self
      def list
        Dir.glob DIRECTORY.join("**", "*.*").to_s
      end

      def all
        list.map { |p| self.new(p) }
      end

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

    # Render the page into its template.
    def render
      begin
        output.content = context.render(template.content) { to_html }
        output.error = false
      rescue => e
        output.content = ERB.new(Template::ERROR.read).result(binding)
        output.error = e
      end

      output
    end

    def output
      @output ||= Output.new(self)
    end

    # Returns an instance of Template that holds all the information about the
    # template for the current page.
    def template
      @template ||= Template.new(self)
    end

    # Returns a Context instance tied to the current page. All pages will be
    # rendered through this context.
    def context
      @context ||= Context.new(self)
    end

    # Returns the raw content from the page
    def raw
      @raw ||= @pathname.read
    end

    # Returns all the content under the YAML Front Matter stil unprocessed.
    def content
      @content ||= raw.split(/---\n/).pop.lstrip
    end

    # Returns all the content under the YAML Front Matter in HTML format.
    # Depending if the file path ends with ".md" or not the content will be
    # processed through <tt>Redcarpet</tt> or not.
    def to_html
      @html ||= markdown? ? context.markdown(content) : content
    end

    def markdown?
      @pathname.extname == ".md"
    end

    # Returns a freezed OpenStruct loaded with all the data present in the
    # YAML Front Matter.
    def data
      @data ||= OpenStruct.new(YAML.load(raw)).freeze
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

    private

    def route
      @route ||= data.route || Routing.routes.fetch(model.intern, DEFAULT_ROUTE)
    end

    def interpolate_chunk(chunk)
      data.send(chunk).parameterize if data.send(chunk)
    end
  end
end

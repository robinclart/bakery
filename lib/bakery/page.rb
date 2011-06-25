module Bakery
  class Page
    def initialize(path)
      @pathname       = Pathname.new(path).cleanpath
      @dirname        = @pathname.relative_path_from(DIRECTORY).dirname
      @filename       = @pathname.basename(".md")
      @extname        = @filename.extname
      @basename       = @filename.basename(@extname).to_s

      mix_helpers!
    end

    DIRECTORY = Pathname.new("site")

    DEFAULT_ROUTE = ":dirname/:filename"

    attr_reader :pathname

    attr_reader :extname

    attr_reader :basename

    def path
      @pathname.to_s
    end

    def url
      Routing.root + url_path.sub(/index.htm[l]?$/, "")
    end

    def url_path
      Pathname.new(interpolate_route + extname).cleanpath.to_s
    end

    def model
      data.model || "page"
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
        output.error = true
      end

      { content: output.content, error: output.error }
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

    def interpolate_route(pattern = %r/:[a-z_]+/) #:nodoc:
      route.gsub(pattern) do |chunk|
        case chunk.gsub!(":", "")
        when "dirname"          then dirname
        when "filename"         then basename
        when /^day|month|year$/ then published_at(chunk)
        else interpolate_chunk(chunk)
        end
      end
    end

    def published_at(meth = nil) #:nodoc:
      date = Date.parse(data.published_at) if data.published_at

      if meth && date
        date.send(meth).to_s
      else
        date
      end
    end

    def self.where(conditions = {})
      all.select do |page|
        conditions.all? { |k,v| page.data.send(k) == v }
      end
    end

    def self.all
      list.map { |p| self.new(p) }
    end

    def self.list
      Dir.glob DIRECTORY.join("**", "*.*").to_s
    end

    private

    def route
      data.route || Bakery::Routing.routes(model.intern) || DEFAULT_ROUTE
    end

    def interpolate_chunk(chunk)
      data.send(chunk).parameterize if data.send(chunk)
    end

    # Extends the context with all the built-in helpers and with the helpers
    # specified in the <tt>config.helpers</tt> statement from the Bakefile.
    def mix_helpers!
      Bakery::Helpers.constants.each do |helper|
        context.extend "Bakery::Helpers::#{helper}".constantize
      end
    end
  end
end

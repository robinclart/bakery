module Bakery
  class Item
    def initialize(path)
      @path           = Pathname.new(path).cleanpath
      @dirname        = @path.relative_path_from(DIRECTORY).dirname
      @filename       = @path.basename(".md")
      @extname        = @filename.extname
      @basename       = @filename.basename(@extname).to_s
      @output_error   = false

      mix_helpers!
    end

    DIRECTORY = Pathname.new("site")
    PUBLIC_DIRECTORY = Pathname.new("public")
    OUTPUT_PATH = ":dirname/:filename"

    attr_reader :extname, :basename, :output_error

    def pathname
      @path
    end

    def path
      @path.to_s
    end

    def model
      data.model || "page"
    end

    # Returns the filename of the item's file without the ".md" if it's present.
    def filename
      @filename.to_s
    end

    def dirname
      @dirname.to_s
    end

    # Returns the output path of an item.
    #
    # By default the items from the "page" model will be rendered at
    # the root of the public directory. All the other models that you have
    # supplied in your Bakefile will be rendered in ":base/:sub/:name"
    #
    # If the output path have been overwritten in the Bakefile the path
    # will be interpolated and every keywords found (a string beginning by a
    # colon) found will be:
    #
    # - replaced by the value of the base directory (for the :base keywords).
    # - replaced by the value of the sub directory (for the :sub keywords).
    # - replaced by the value of the filename directory (for the :name keywords).
    # - replaced by the value of the day, month, year of the published_at
    #   field if it is present in the YAML Front Matter (for the :day, :month
    #   and :year keywords).
    # - replaced by the value of the same keyword in the YAML Front Matter.
    # - removed if none of the previous conditions were fulfilled.
    #
    # Example of interpolation configuration one can found in a Bakefile:
    #
    #   config.output_paths.merge!({
    #     :post => ":base/:author/:year/:month/:day/:name"
    #   })
    #
    # This will give: "public/posts/john-doe/2011/4/29/hello-world.html".
    #
    # or for this:
    #
    #   config.output_paths.merge!({
    #     :post => ":base/:author/:year/:month/:day/:name/index"
    #   })
    #
    # This will give: "public/posts/john-doe/2011/4/29/hello-world/index.html".
    #
    # Note that the extension are automatically appended to the path.
    def output_path
      p = data.path || Bakery.config.output_paths[model.intern] || OUTPUT_PATH
      PUBLIC_DIRECTORY.join(interpolate_path(p) + @extname).cleanpath.to_s
    end

    # Compiles the item into its template.
    def output!
      context.render(template.content) { to_html }
    rescue => e
      @output_error = e
      ERB.new(Template::ERROR.read).result(binding)
    end

    # Returns an instance of Template that holds all the information about the
    # template for the current item.
    def template
      @template ||= Template.new(self)
    end

    # Returns a Context instance tied to the current item. All items will be
    # rendered through this context.
    def context
      @context ||= Context.new(self)
    end

    # Returns the raw content from the item's file.
    def raw
      @raw ||= @path.read
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
      @path.extname == ".md"
    end

    # Returns a freezed OpenStruct loaded with all the data present in the
    # YAML Front Matter.
    def data
      @data ||= OpenStruct.new(YAML.load(raw)).freeze
    end

    def self.where(conditions = {})
      all.select do |item|
        conditions.all? { |k,v| item.data.send(k) == v }
      end
    end

    def self.all
      list.map { |p| self.new(p) }
    end

    def self.list
      Dir.glob DIRECTORY.join("**", "*.*").to_s
    end

    private

    # Extends the context with all the built-in helpers and with the helpers
    # specified in the <tt>config.helpers</tt> statement from the Bakefile.
    def mix_helpers!
      Bakery.config.helpers.each { |h| context.extend h }
    end

    def interpolate_path(p, pattern = %r/:[a-z_]+/) #:nodoc:
      p.gsub(pattern) do |meth|
        case meth
          when ":dirname"  then dirname
          when ":filename" then basename
          else data_chunk(meth.sub(/:/, ""))
        end
      end
    end

    def data_chunk(m) #:nodoc:
      return date_chunk(m) if m.match(/^day|month|year$/)
      return data.send(m).parameterize if data.send(m)
    end

    def date_chunk(m) #:nodoc:
      Date.parse(data.published_at).send(m).to_s if data.published_at
    end
  end
end

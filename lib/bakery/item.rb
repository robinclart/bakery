module Bakery
  class Item
    def initialize(path)
      @path         = path
      @basename     = File.basename(@path, ".md")
      @extname      = File.extname(@basename)
      @modelname    = @path.split(File::SEPARATOR).first.singularize
      @output_path  = @path.gsub(base_directory, output_directory).gsub(/.md$/, "")
      @output_error = false

      mix_helpers!
    end

    attr_reader :path, :basename, :extname, :modelname,
                :output_path, :output_error

    # Returns a context instance tied to the current item. All items will be
    # rendered through this context.
    def context
      @context ||= Context.new(self)
    end

    # Returns an instance of Template that holds all the information about the
    # template for the current item.
    def template
      @template ||= Template.new(self)
    end

    # Extends the context with all the built-in helpers and with the helpers
    # specified in the <tt>config.helpers</tt> statement from the Bakefile.
    def mix_helpers!
      Bakery.config.helpers.each { |h| context.extend h }
    end

    def self.all(model = nil)
      list(model).map { |p| self.new(p) }
    end

    def self.list(model = nil)
      model = model ? model.pluralize : Bakery.config.models.map(&:pluralize).join(",")
      Dir[File.join("{#{model}}", "**", "*.*")]
    end

    # == Bakery Directories
    #
    # === Output Directory Interpolation
    #
    # If the output directory have been overwritten in the Bakefile the path
    # will be interpolated. Every instances of the :day, :month, :year, :base
    # and :base_directory keywords will be:
    #
    # - replaced by the value of the day, month, year of the published_at
    #   field if it is present in the YAML Front Matter.
    # - replaced by the value of the base directory (for the :base and
    #   the :base_directory keywords).
    # - removed if none of the previous conditions were fulfilled.
    #
    # Example of interpolation configuration one can found in a Bakefile:
    #
    #   config.output_directories.merge!({
    #     :post => "public/:base/:year/:month/:day"
    #   })
    #
    # This will give: "public/posts/2011/4/29/hello-world.html".
    module Directories
      # Returns the base directory of an item. The name of the directory is the
      # pluralized version of the model name for a given item. For example a
      # post item will return "posts".
      def base_directory
        modelname.pluralize
      end

      # Returns the output directory of an item. See the head of this module for
      # more information about the output directory interpolation.
      #
      # By default the items from the "page" model will be rendered at
      # the root of the public directory. All the other models that you have
      # supplied in your Bakefile will be rendered in "public/:base_directory"
      def output_directory
        dir = Bakery.config.output_directories[modelname.intern] || ":base"
        interpolate_output_directory(dir)
      end

      private

      def interpolate_output_directory(dir) #:nodoc:
        sections = dir.split(File::SEPARATOR).map do |section|
          if section.eql?(":base")
            base_directory
          elsif section.match(/^:(year|month|day)$/)
            data.published_at ? date_chunk($1) : ""
          elsif data.send(section.gsub(":", ""))
            data.send(section.gsub(":", "")).parameterize
          else
            section.sub(/^:.*/, "")
          end
        end

        File.join *sections.unshift("public")
      end

      def date_chunk(m) #:nodoc:
        Date.parse(data.published_at).send(m).to_s
      end
    end

    module Extraction
      def output!
        context.render(template.content) { to_html }
      rescue => e
        @output_error = e
        ERB.new(File.read(Template::ERROR)).result(binding)
      end

      # Returns the raw content from the item file.
      def raw
        @raw ||= File.read(path)
      end

      # Returns all the content under the YAML Front Matter stil unprocessed.
      def content
        @content ||= raw.split(/---\n/).pop.lstrip
      end

      # Returns all the content under the YAML Front Matter in HTML format.
      # Depending if the file path ends with ".md" or not the content will be
      # processed through <tt>Redcarpet</tt> or not.
      def to_html
        @html ||= markdown? ? Redcarpet.new(content).to_html : content
      end

      # Returns a freezed OpenStruct loaded with all the data present in the
      # YAML Front Matter.
      def data
        @data ||= OpenStruct.new(YAML.load(raw)).freeze
      end

      private

      def markdown?
        !!path.match(/.md$/)
      end
    end

    include Directories
    include Extraction
  end
end

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

    attr_reader :path
    attr_reader :output_path
    attr_reader :basename
    attr_reader :extname
    attr_reader :modelname
    attr_reader :output_error

    # Returns a context instance tied to the current item. All items will be
    # rendered through this context.
    def context
      @context ||= Context.new(self)
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
        context.render(template_content) { to_html }
      rescue => e
        @output_error = e
        error_template_path = File.expand_path("../templates/error.html.erb", __FILE__)
        ERB.new(File.read(error_template_path)).result(binding)
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
        @html ||= path.match(/.md$/) ? Redcarpet.new(content).to_html : content
      end

      # Returns a freezed OpenStruct loaded with all the data present in the
      # YAML Front Matter.
      def data
        @data ||= OpenStruct.new(YAML.load(raw)).freeze
      end
    end

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
    module Template
      # Returns the content of the item's template.
      def template_content
        @template_content ||= File.read(template_path)
      end

      # Returns the template path for the current item.
      def template_path
        @template_path ||= resolve_template_path(template_basename)
      end

      # Returns the basename of the item's template (without the ".erb"
      # extension).
      def template_basename
        available_template_names.first or fallback_template_name
      end

      private

      # Returns an array of all the availables template names (without the
      # ".erb" extension) for the current item except the fallback one.
      def available_template_names
        hypothetical_template_names.select do |name|
          File.exists? resolve_template_path(name)
        end
      end

      # Returns an array of all the suitable template names (without the ".erb"
      # extension) for the current item except the fallback one.
      def hypothetical_template_names
        [data.template, base_template_name, model_template_name].compact
      end

      def base_template_name #:nodoc:
        basename unless basename == fallback_template_name
      end

      def model_template_name #:nodoc:
        [modelname, extname].join
      end

      def fallback_template_name #:nodoc:
        "index.html"
      end

      def resolve_template_path(name) #:nodoc:
        File.join("templates", "#{name}.erb")
      end
    end

    include Directories
    include Extraction
    include Template
  end
end

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

    def context
      @context ||= Context.new(self)
    end

    def mix_helpers!
      Bakery.config.helpers.each { |h| context.extend h }
    end

    module Naming
      def base_directory
        modelname.pluralize
      end

      def output_directory
        Bakery.config.output_directories[modelname.intern] || "public/#{base_directory}"
      end
    end

    module Extraction
      def output!
        context.render(template_content) { to_html }
      rescue => e
        @output_error = e
        ERB.new(File.read(File.expand_path("../templates/error.html.erb", __FILE__))).result(binding)
      end

      def raw
        @raw ||= File.read(path)
      end

      def content
        @content ||= raw.split(/---\n/).pop.lstrip
      end

      def to_html
        @html ||= path.match(/.md$/) ? Redcarpet.new(content).to_html : content
      end

      def data
        @data ||= OpenStruct.new(YAML.load(raw)).freeze
      end
    end

    module Template
      def template_content
        @template_content ||= File.read(template_path)
      end

      # This method will go down the template lookup procedure and will
      # return the first file path to match an existing file.
      #
      # The lookup order is as follow:
      #
      #   1 The template name supplied in the data section
      #   2 A template with the same basename
      #   3 A template with the name of the item class (Page, Post, etc…)
      #   4 The index template file
      def template_path
        @template_path ||= resolve_template_path(template_name)
      end

      private

      def template_name
        available_template_names.first or "index.html"
      end

      def available_template_names
        hypothetical_template_names.select do |name|
          File.exists? resolve_template_path(name)
        end
      end

      def hypothetical_template_names
        [data_template_name, base_template_name, model_template_name].compact
      end

      def data_template_name
        data.template
      end

      def base_template_name
        basename unless basename == fallback_template_name
      end

      def model_template_name
        [modelname, extname].join
      end

      def fallback_template_name
        "index.html"
      end

      def resolve_template_path(name)
        File.join("templates", "#{name}.erb")
      end
    end

    module Finder
      def find(r)
        list.each { |p| return self.new(p) if p.match(r) }

        nil
      end

      def all(model = nil)
        list(model).map { |p| self.new(p) }
      end

      def list(model = nil)
        model = model ? model.pluralize : Bakery.config.models.map(&:pluralize).join(",")
        Dir[File.join("{#{model}}", "**", "*.*")]
      end
    end

    include Naming
    include Extraction
    include Template
    extend Finder
  end
end

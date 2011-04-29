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

    def self.all(model = nil)
      list(model).map { |p| self.new(p) }
    end

    def self.list(model = nil)
      model = model ? model.pluralize : Bakery.config.models.map(&:pluralize).join(",")
      Dir[File.join("{#{model}}", "**", "*.*")]
    end

    module Directories
      def base_directory
        modelname.pluralize
      end

      def output_directory
        dir = Bakery.config.output_directories[modelname.intern] || ":base"
        interpolate_output_directory(dir.clone)
      end

      private

      def interpolate_output_directory(dir)
        dir.scan(/:([a-z0-9_-]+)/i,).flatten.each do |m|
          if m.match(/^year|month|day$/) and data.published_at
            dir.sub!(/:#{m}/, date_chunk(m))
          elsif m.match(/^base|base_directory$/)
            dir.sub!(/:#{m}/, base_directory)
          else
            dir.sub!(/\/:#{m}/, "")
          end
        end

        File.join("public", dir).sub(/\/+$/, "")
      end

      def date_chunk(m)
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

      def template_path
        @template_path ||= resolve_template_path(template_basename)
      end

      def template_basename
        available_template_names.first or fallback_template_name
      end

      private

      def available_template_names
        hypothetical_template_names.select do |name|
          File.exists? resolve_template_path(name)
        end
      end

      def hypothetical_template_names
        [data.template, base_template_name, model_template_name].compact
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

    include Directories
    include Extraction
    include Template
  end
end

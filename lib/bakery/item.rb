module Bakery
  class Item
    def initialize(path)
      @path = path
      @output_error = false

      mix_helpers!
    end

    attr_reader :path, :output_error

    # Returns the basename of the item's file without the ".md" if it's present.
    def basename
      @basename ||= File.basename(path, ".md")
    end

    # Returns the extension of the item's basename.
    def extname
      @extname ||= File.extname(basename)
    end

    # Return the item's model.
    def modelname
      @modelname ||= base_directory.singularize
    end

    # Returns the base directory of an item. The name of the directory is the
    # pluralized version of the model name for a given item. For example a
    # post item will return "posts".
    def base_directory
      @base_directory ||= path.split(File::SEPARATOR).first
    end

    # Returns the output directory of an item.
    #
    # By default the items from the "page" model will be rendered at
    # the root of the public directory. All the other models that you have
    # supplied in your Bakefile will be rendered in "public/:base_directory"
    #
    # If the output directory have been overwritten in the Bakefile the path
    # will be interpolated and every keywords found (a string beginning by a
    # colon) found will be:
    #
    # - replaced by the value of the base directory (for the :base and
    #   the :base_directory keywords).
    # - replaced by the value of the day, month, year of the published_at
    #   field if it is present in the YAML Front Matter (for the :day, :month
    #   and :year keywords).
    # - replaced by the value of the same keyword in the YAML Front Matter.
    # - removed if none of the previous conditions were fulfilled.
    #
    # Example of interpolation configuration one can found in a Bakefile:
    #
    #   config.output_directories.merge!({
    #     :post => ":base/:author/:year/:month/:day"
    #   })
    #
    # This will give: "public/posts/john-doe/2011/4/29".
    def output_directory
      dir = Bakery.config.output_directories[modelname.intern] || ":base"
      interpolate_output_directory(dir)
    end

    # Returns the output path.
    def output_path
      @path.gsub(base_directory, output_directory).gsub(/.md$/, "")
    end

    # Compiles the item into its template.
    def output!
      context.render(template.content) { to_html }
    rescue => e
      @output_error = e
      ERB.new(File.read(Template::ERROR)).result(binding)
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

    def self.where(conditions = {})
      all(conditions.delete(:model)).select do |item|
        conditions.all? { |k,v| item.data.send(k) == v }
      end
    end

    def self.all(model = nil)
      list(model).map { |p| self.new(p) }
    end

    def self.list(model = nil)
      model = model ? model.pluralize : Bakery.config.models.map(&:pluralize).join(",")
      Dir[File.join("{#{model}}", "**", "*.*")]
    end

    private

    # Extends the context with all the built-in helpers and with the helpers
    # specified in the <tt>config.helpers</tt> statement from the Bakefile.
    def mix_helpers!
      Bakery.config.helpers.each { |h| context.extend h }
    end

    def interpolate_output_directory(dir) #:nodoc:
      sections = dir.split(File::SEPARATOR).map do |section|
        if section.eql?(":base")
          base_directory
        elsif section.match(/^:(year|month|day)$/)
          date_chunk $1
        elsif section.match(/^:(.*)$/)
          data_chunk $1
        else
          section
        end
      end

      File.join *sections.compact.unshift("public")
    end

    def data_chunk(m) #:nodoc:
      data_value = data.send(m)
      data_value.parameterize if data_value
    end

    def date_chunk(m) #:nodoc:
      Date.parse(data.published_at).send(m).to_s if data.published_at
    end

    def markdown? #:nodoc:
      !!path.match(/.md$/)
    end
  end
end

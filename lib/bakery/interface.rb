module Bakery
  module Interface extend self
    def start
      bootload
      receiver.start
      exit
    end

    private

    def bootload
      unless Commands.tasks.key?(ARGV.first)
        ARGV.unshift("output") if implicit_output?
        ARGV.unshift("generate") if implicit_generate?
      end

      unless command_run_without_bakefile?
        begin
          load "Bakefile"
        rescue LoadError
          puts "This is not a bakery. Please run 'bake new NAME' first."
          exit
        end

        Dir["lib/*.rb"].each { |file| require file }
      end
    end

    def receiver
      is?(/^g(enerate)?$/) ? Generators : Commands
    end

    def is?(name, pos = 0)
      !ARGV[pos].nil? && !!ARGV[pos].match(name)
    end

    def command_run_without_bakefile?
      is?(/^new$/, 1) or is?(/^help|version$/)
    end

    def implicit_output?
      ARGV.empty? or is?(/^-f|--force|--no-force$/)
    end

    def implicit_generate?
      is?(/^new$/) or is?(/^output$/)
    end
  end
end
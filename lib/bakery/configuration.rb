module Bakery
  module Configuration extend self
    def load!
      load "Bakefile"
    rescue LoadError
      puts "This is not a bakery. Please run 'bake init' first."
      exit
    end
  end
end
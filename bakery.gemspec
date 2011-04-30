# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bakery/version"

Gem::Specification.new do |s|
  s.name        = "bakery"
  s.version     = Bakery::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Robin Clart"]
  s.email       = ["robin@charlin.be"]
  s.homepage    = "http://rubygems.org/gems/bakery"
  s.summary     = "A static website generator"
  s.description = "Bakery makes it easy to maintain a file based website."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "bakery"

  s.add_dependency "activesupport", ">= 3.0.0"
  s.add_dependency "redcarpet", ">= 1.11.3"
  s.add_dependency "sinatra", ">= 1.1.0"
  s.add_dependency "thor", ">= 0.14.6"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "sdoc", ">= 0.2.20"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

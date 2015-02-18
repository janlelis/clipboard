# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem

$:.unshift File.expand_path("../lib", __FILE__)
require 'clipboard/version'

Gem::Specification.new do |s|
  s.name = 'clipboard'
  s.version = Clipboard::VERSION

  s.authors = ["Jan Lelis"]
  s.summary = 'Easy access to the clipboard on Linux, MacOS and Windows.'
  s.description = 'Easy access to the clipboard on Linux, MacOS and Windows (Clipboard.copy & Clipboard.paste).'
  s.email = 'mail@janlelis.de'
  s.homepage = %q{http://github.com/janlelis/clipboard}
  s.requirements =  ["On Linux (or other X), you will need xclip. You can install it on debian/ubuntu with: sudo apt-get install xclip"]
  s.requirements += ["On Windows, you will need the ffi gem."]
  s.files = Dir.glob(%w[{lib,spec}/**/*.rb [A-Z]* [A-Z]*.rdoc]) + %w{clipboard.gemspec}
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>=2'
end

# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem

Gem::Specification.new do |s|
  s.name = 'clipboard'
  s.version = File.read('VERSION').chomp

  s.authors = ["Jan Lelis"]
  s.date = '2011-02-08'
  s.summary = 'Access the clipboard on all systems.'
  s.description = 'Access the clipboard on all systems (Clipboard.copy & Clipboard.paste).'
  s.email = 'mail@janlelis.de'
  s.homepage = %q{http://github.com/janlelis/clipboard}
  s.required_rubygems_version = ">= 1.3.6"
  s.requirements =  ["On Linux (or other X), you need xclip. Install it on debian/ubuntu with sudo apt-get install xclip"]
  s.requirements += ["On Windows, you need the ffi gem."]
  s.files = Dir.glob(%w[{lib,spec}/**/*.rb [A-Z]* [A-Z]*.rdoc]) + %w{clipboard.gemspec .gemtest}
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>=2'
end

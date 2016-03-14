# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem

$:.unshift File.expand_path("../lib", __FILE__)
require 'clipboard/version'

Gem::Specification.new do |s|
  s.name = 'clipboard'
  s.version = Clipboard::VERSION

  s.authors = ["Jan Lelis"]
  s.summary = "Access to the clipboard on Linux, MacOS, Windows, and Cygwin."
  s.description = "Access to the clipboard on Linux, MacOS, Windows, and Cygwin: Clipboard.copy, Clipboard.paste, Clipboard.clear"
  s.email = "mail@janlelis.de"
  s.homepage = "http://github.com/janlelis/clipboard"
  s.license = "MIT"
  s.requirements = [
    "On Linux (or other X), you will need xclip. On debian/ubuntu this is: sudo apt-get install xclip",
    "On Windows, you will need the ffi gem.",
  ]
  s.files = Dir.glob(%w[{lib,spec}/**/*.rb [A-Z]*.txt [A-Z]*.md]) + %w{clipboard.gemspec}

  s.required_ruby_version = '>= 1.9.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>=2'
end

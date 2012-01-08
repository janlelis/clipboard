# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem

Gem::Specification.new do |s|
  s.name = 'clipboard'
  s.version = File.read('VERSION').chomp

  s.authors = ["Jan Lelis"]
  s.summary = 'Easy access to the clipboard on all systems.'
  s.description = 'Easy access to the clipboard on all systems (Clipboard.copy & Clipboard.paste).'
  s.email = 'mail@janlelis.de'
  s.homepage = %q{http://github.com/janlelis/clipboard}
  s.requirements =  ["On Linux (or other X), you need xclip. Install it on debian/ubuntu with: sudo apt-get install xclip"]
  s.requirements << ["On Windows, you need the ffi gem."]
  s.files = Dir.glob(%w[{lib,spec}/**/*.rb [A-Z]* [A-Z]*.rdoc]) + %w{clipboard.gemspec}
end

# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem

Gem::Specification.new do |s|
  s.name = 'clipboard'
  s.version = File.read('VERSION').chomp

  s.authors = ["Jan Lelis"]
  s.date = '2010-12-15'
  s.summary = 'Access the clipboard on all systems.'
  s.description = 'Access the clipboard on all systems (Clipboard.copy & Clipboard.paste).'
  s.email = 'mail@janlelis.de'
  s.homepage = %q{http://github.com/janlelis/clipboard}
  s.rubygems_version = %q{1.3.7}
  s.requirements =  ["On Linux (or other X), you need xclip. Install it on debian/ubuntu with sudo apt-get install xclip"]
  s.requirements << ["On Windows, you need the ffi gem."]
  s.files = %w[
    LICENSE
    README.rdoc
    Rakefile
    VERSION
    clipboard.gemspec
    lib/clipboard.rb
    version.rb
  ]
  s.extra_rdoc_files = %w[LICENSE README.rdoc]
  s.add_dependency 'zucker', '>= 8'
end

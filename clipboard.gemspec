# frozen_string_literal: true

$:.unshift File.expand_path("../lib", __FILE__)
require 'clipboard/version'

Gem::Specification.new do |s|
  s.name     = 'clipboard'
  s.version  = Clipboard::VERSION
  s.authors  = ["Jan Lelis"]
  s.email    = ["hi@ruby.consulting"]
  s.summary  = "Access to the clipboard on Linux, MacOS, Windows, and Cygwin."
  s.description = "Access to the clipboard on Linux, MacOS, Windows, and Cygwin: Clipboard.copy, Clipboard.paste, Clipboard.clear"
  s.homepage = "https://github.com/janlelis/clipboard"
  s.license  = "MIT"
  s.requirements = [
    "Linux: You need xclip or xsel. On debian/ubuntu run: sudo apt-get install xsel",
    "Windows: You need the ffi gem",
  ]
  s.files = Dir.glob(%w[{lib,spec}/**/*.rb [A-Z]*.txt [A-Z]*.md]) + %w{clipboard.gemspec}

  s.required_ruby_version = '>= 1.9.3'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3'
  # s.add_development_dependency 'ffi', '~> 1.9'
  # s.add_development_dependency 'gtk3', '~> 3'
end

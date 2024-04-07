# frozen_string_literal: true

$:.unshift File.expand_path("../lib", __FILE__)
require 'clipboard/version'

Gem::Specification.new do |s|
  s.name     = 'clipboard'
  s.version  = Clipboard::VERSION
  s.authors  = ["Jan Lelis"]
  s.email    = ["hi@ruby.consulting"]
  s.summary  = "Access the system clipboard 📋︎ on Linux, MacOS, Windows, WSL, Cygwin, GTK, or Java."
  s.description = "Access the system clipboard 📋︎ on Linux, MacOS, Windows, WSL, Cygwin, GTK, or Java. Usage is as simple as calling Clipboard.copy or Clipboard.paste!"
  s.homepage = "https://github.com/janlelis/clipboard"
  s.license  = "MIT"
  s.metadata = { "rubygems_mfa_required" => "true" }
  s.requirements = [
    "Linux-X11: xclip or xsel",
    "Linux-Wayland: wl-clipboard",
    "Windows: ffi gem",
  ]
  s.files = Dir.glob(%w[{lib,spec}/**/*.rb [A-Z]*.txt [A-Z]*.md]) + %w{clipboard.gemspec}

  s.required_ruby_version = '>= 3.0'
  s.add_development_dependency 'rake', '~> 13.2'
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rubocop', '~> 1.6'
  # s.add_development_dependency 'ffi', '~> 1.9'
  # s.add_development_dependency 'gtk3', '~> 3'
end

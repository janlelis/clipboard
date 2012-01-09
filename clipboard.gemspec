# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem

Gem::Specification.new do |s|
  s.name = 'clipboard'
  s.version = File.read('VERSION').chomp

  s.authors = ["Jan Lelis"]
  s.summary = 'Easy access to the clipboard on Linux, MacOS and Windows.'
  s.description = 'Easy access to the clipboard on Linux, MacOS and Windows (Clipboard.copy & Clipboard.paste).'
  s.email = 'mail@janlelis.de'
  s.homepage = %q{http://github.com/janlelis/clipboard}
  s.requirements =  ["On Linux (or other X), you need xclip. You can install it on debian/ubuntu with: sudo apt-get install xclip"]
  s.requirements += ["On Windows, you need the ffi gem."]
  s.files = Dir.glob(%w[{lib,spec}/**/*.rb [A-Z]* [A-Z]*.rdoc]) + %w{clipboard.gemspec .gemtest}
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>=2'

  len = s.homepage.size
  s.post_install_message = \
   ("       ┌── " + "info ".ljust(len-2,'%')            + "─┐\n" +
    " J-_-L │ "   + s.homepage                          + " │\n" +
    "       ├── " + "usage ".ljust(len-2,'%')           + "─┤\n" +
    "       │ "   + "require 'clipboard'".ljust(len,' ')     + " │\n" +
    "       │ "   + "Clipboard.copy '42'".ljust(len,' ')     + " │\n" +
    "       │ "   + "Clipboard.paste #=> 42".ljust(len,' ')  + " │\n" +
    "       └─"   + '─'*len                             + "─┘").gsub('%', '─') # 1.8 workaround
end

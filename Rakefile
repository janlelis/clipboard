require 'rubygems'
require 'rake'
# require 'bundler'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "clipboard"
    gem.summary = %Q{Access the clipboard on all systems}
    gem.description = %Q{Access the clipboard on all systems (Clipboard.write & Clipboard.read)}
    gem.email = "mail@janlelis.de"
    gem.homepage = "http://github.com/janlelis/clipboard"
    gem.authors = ["Jan Lelis"]
    gem.add_development_dependency "jeweler", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.add_dependency('zucker', '>= 4')
    gem.requirements << 'To use this gem on linux (or other X), you need xclip'
    gem.requirements << 'To use this gem on windows, you need the win32-clipboard gem'
#    gem.add_bundler_dependencies
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'doc'
  rdoc.title = "clipboard #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

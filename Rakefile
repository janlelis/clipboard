require 'rubygems'
require 'rake'

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
    gem.add_dependency('zucker', '>= 4')
    gem.requirements << 'on linux (or other X), you need xclip'
    gem.requirements << 'on windows, you need the win32-clipboard gem'
        
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

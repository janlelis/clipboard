require 'rake'
require 'fileutils'
require "rspec/core/rake_task"

task :test => :spec
task :default => :spec
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--backtrace --color'
end

def gemspec
  @gemspec ||= eval(File.read('clipboard.gemspec'), binding, 'clipboard.gemspec')
end

desc "Build the gem"
task :gem => :gemspec do
  sh "gem build clipboard.gemspec"
  FileUtils.mkdir_p 'pkg'
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", 'pkg'
end

desc "Install the gem locally (without docs)"
task :install => :gem do
  sh %{gem install pkg/#{gemspec.name}-#{gemspec.version}.gem --no-rdoc --no-ri}
end

desc "Generate the gemspec"
task :generate do
  puts gemspec.to_ruby
end

desc "Validate the gemspec"
task :gemspec do
  require 'rubygems/user_interaction' # rubygems 1.5.0
  gemspec.validate
end


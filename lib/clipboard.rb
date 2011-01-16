module Clipboard
  extend self
  VERSION = File.read( (File.dirname(__FILE__) + '/../VERSION') ).chomp

  os = proc do
    case RbConfig::CONFIG['host_os']
    when /mac|darwin/ then 'mac'
    when /linux|cygwin/ then 'linux'
    when /mswin|mingw/ then 'windows'
    when /bsd/ then 'linux'
    # when /solaris|sunos/ then 'linux' # needs testing..
    else
      raise "You OS is not supported -> fork me"
    end
  end

  require "clipboard/#{os.call}"
end

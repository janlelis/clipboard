module Clipboard
  extend self
  VERSION = File.read( (File.dirname(__FILE__) + '/../VERSION') ).chomp

  def self.os
    case RbConfig::CONFIG['host_os']
    when /mac|darwin/ then 'mac'
    when /linux|cygwin/ then 'linux'
    when /mswin|mingw/ then 'windows'
#    when /bsd/ then 'bsd'
#    when /solaris|sunos/ then 'solaris'
    else
      raise "You OS is not supported -> fork me"
    end
  end

  require "clipboard/#{os}"
end
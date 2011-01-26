module Clipboard
  extend self
  VERSION = File.read( (File.dirname(__FILE__) + '/../VERSION') ).chomp

  def self.detect_os
    os = case RbConfig::CONFIG['host_os']
    when /mac|darwin/ then 'mac'
    when /linux|cygwin/ then 'linux'
    when /mswin|mingw/ then 'windows'
    when /bsd/ then 'linux'
    # when /solaris|sunos/ then 'linux' # needs testing..
    else
      raise "You OS is not supported -> fork me"
    end

    require "clipboard/#{os}"
    @@implementation = eval("Clipboard::#{os.capitalize}")
  end

  def paste(*args)
    @@implementation.paste(*args)
  end

  def clear(*args)
    @@implementation.clear(*args)
  end

  def copy(*args)
    @@implementation.copy(*args)
  end
end

Clipboard.detect_os
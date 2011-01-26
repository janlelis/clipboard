module Clipboard
  extend self
  VERSION = File.read( (File.dirname(__FILE__) + '/../VERSION') ).chomp
  class << self
    attr_accessor :implementation
  end

  def self.detect_os
    os = case RbConfig::CONFIG['host_os']
    when /mac|darwin/ then 'mac'
    when /linux|cygwin/ then 'linux'
    when /mswin|mingw/ then 'windows'
    when /bsd/ then 'linux'
    # when /solaris|sunos/ then 'linux' # needs testing..
    else
      $stderr.puts "Your OS(#{os}) is not supported, using file-based clipboard"
      'file'
    end

    require "clipboard/#{os}"
    self.implementation = eval("Clipboard::#{os.capitalize}")
  end

  def paste(*args)
    Clipboard.implementation.paste(*args)
  end

  def clear(*args)
    Clipboard.implementation.clear(*args)
  end

  def copy(*args)
    Clipboard.implementation.copy(*args)
  end
end

Clipboard.detect_os
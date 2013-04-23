require 'rbconfig'
require File.dirname(__FILE__) + '/clipboard/version'

module Clipboard
  extend self

  class ClipboardLoadError < Exception
  end

  unless defined? Ocra # see gh#9
    autoload :Linux,   'clipboard/linux'
    autoload :Mac,     'clipboard/mac'
    autoload :Java,    'clipboard/java'
  end
  autoload :Windows, 'clipboard/windows'
  autoload :File,    'clipboard/file'

  def self.implementation
  return @implementation if @implementation

    os = case RbConfig::CONFIG['host_os']
    when /mac|darwin/        then :Mac
    when /linux|bsd|cygwin/  then :Linux
    when /mswin|mingw/       then :Windows
    # when /solaris|sunos/     then :Linux # needs testing..
    else
      raise ClipboardLoadError, "Your OS(#{ RbConfig::CONFIG['host_os'] }) is not supported, using file-based (fake) clipboard"
    end

    @implementation = Clipboard.const_get os
  rescue ClipboardLoadError => e
    $stderr.puts e.message if $VERBOSE
    @implementation = Clipboard::File
  end

  def self.implementation=(val)
    @implementation = val
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

Clipboard.implementation

# frozen_string_literal: true

require 'rbconfig'

require_relative 'clipboard/version'
require_relative 'clipboard/utils'

module Clipboard
  extend self

  class ClipboardLoadError < Exception
  end

  unless defined? Ocra # see gh#9
    autoload :Linux,          'clipboard/linux'
    autoload :LinuxWayland,   'clipboard/linux_wayland'
    autoload :Mac,            'clipboard/mac'
    autoload :Java,           'clipboard/java'
    autoload :Cygwin,         'clipboard/cygwin'
    autoload :Wsl,            'clipboard/wsl'
    autoload :Gtk,            'clipboard/gtk'
  end
  autoload :Windows, 'clipboard/windows'
  autoload :File,    'clipboard/file'

  def self.implementation
    return @implementation if @implementation

    os = case RbConfig::CONFIG['host_os']
    when /mac|darwin/        then :Mac
    when /linux|bsd/         then :Linux
    when /mswin|mingw/       then :Windows
    when /cygwin/            then :Cygwin
    else
      raise ClipboardLoadError, "Your OS(#{ RbConfig::CONFIG['host_os'] }) is not supported"
    end

    # Running additional check to detect if running in Microsoft WSL or Wayland
    if os == :Linux
      require "etc"
      if Etc.respond_to?(:uname) && Etc.uname[:release] =~ /Microsoft/ # uname was added in ruby 2.2
        os = :Wsl
      # Only choose Wayland implementation if wl-copy is found, since xclip / xsel *might* work
      elsif ENV["XDG_SESSION_TYPE"] == "wayland" && Utils.executable_installed?("wl-copy")
        os = :LinuxWayland
      end
    end

    @implementation = Clipboard.const_get(os)
  rescue ClipboardLoadError => e
    $stderr.puts "#{e.message}\nUsing file-based (fake) clipboard" unless $VERBOSE == nil
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

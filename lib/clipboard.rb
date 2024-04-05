# frozen_string_literal: true

require_relative 'clipboard/version'
require_relative 'clipboard/utils'
require_relative 'clipboard/clipboard_load_error'

module Clipboard
  extend self

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
    @implementation = Clipboard.const_get(Utils.autodetect_implementation)
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

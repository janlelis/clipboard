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
    autoload :Osc52,          'clipboard/osc52'
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

  def paste(...)
    Clipboard.implementation.paste(...)
  end

  def clear(...)
    Clipboard.implementation.clear(...)
  end

  def copy(...)
    Clipboard.implementation.copy(...)
  end
end

Clipboard.implementation

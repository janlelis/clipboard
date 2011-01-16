require 'zucker/os'
require 'zucker/version'

module Clipboard
  extend self
  VERSION = File.read( (File.dirname(__FILE__) + '/../VERSION') ).chomp

  if OS.windows?
    require 'clipboard/windows'
  else
    require 'open3'
    if OS.mac?
      require 'clipboard/mac'
    else
      require 'clipboard/linux'
    end
  end
end
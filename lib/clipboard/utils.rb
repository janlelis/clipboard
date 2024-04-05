# frozen_string_literal: true

require "rbconfig"
require "open3"

require_relative "clipboard_load_error"

module Clipboard
  module Utils
    extend self

    # Find out which implementation is best to use
    def autodetect_implementation
      os = case RbConfig::CONFIG['host_os']
      when /mac|darwin/        then :Mac
      when /linux|bsd/         then :Linux
      when /mswin|mingw/       then :Windows
      when /cygwin/            then :Cygwin
      else
        raise ClipboardLoadError, "clipboard: Could not find suitable implementation for OS(#{ RbConfig::CONFIG['host_os'] })"
      end

      # Running additional check to detect if running in Microsoft WSL or Wayland
      if os == :Linux
        require "etc"
        if Etc.respond_to?(:uname) && Etc.uname[:release] =~ /Microsoft/ # uname was added in ruby 2.2
          os = :Wsl
        # Only choose Wayland implementation if wl-copy is found, since xclip / xsel *might* work
        elsif ENV["XDG_SESSION_TYPE"] == "wayland" && executable_installed?("wl-copy")
          os = :LinuxWayland
        end
      end

      os
    end

    # Check if a necessary command is available
    def executable_installed?(cmd)
      ENV['PATH'].split(::File::PATH_SEPARATOR).any? do |path|
        ::File.executable?(::File.join(path, cmd))
      end
    end

    # Utility to call external command
    # - pure .popen2 becomes messy with xsel when not reading the output stream
    # - xclip doesn't like to have output stream read
    def popen(cmd, data, read_output_stream = false)
      Open3.popen2(cmd) { |input, output, waiter_thread|
        output_thread = Thread.new { output.read } if read_output_stream

        begin
          input.write data
        rescue Errno::EPIPE
        end

        input.close
        output_thread.value if read_output_stream
        waiter_thread.value
      }
    end
  end
end

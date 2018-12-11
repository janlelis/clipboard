# frozen_string_literal: true

require "open3"

module Clipboard
  module Utils
    extend self

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

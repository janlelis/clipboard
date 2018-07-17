require 'open3'

require_relative 'utils'

module Clipboard
  module Linux
    extend self

    CLIPBOARDS = %w[clipboard primary secondary].freeze

    # check which backend to use
    if Utils.executable_installed?('xclip')
      # xclip will get stuck while copying 1 MiB of data (1048576 bytes)
      WriteCommand = 'xclip'.freeze
      ReadCommand  = 'xclip -o'.freeze
      Selection    = proc{ |x| "-selection #{x}" }.freeze
      ConsumeStdout = false # xclip would get stuck if we consume its stdout
      ConsumeStderr = false # xclip would get stuck if we consume its stderr
    elsif Utils.executable_installed?('xsel')
      # xsel has been tested, which can handle 8 MiB of data (8388608 bytes)
      WriteCommand = 'xsel -i'.freeze
      ReadCommand  = 'xsel -o'.freeze
      Selection    = { 'clipboard' => '-b', 'primary' => '-p', 'secondary' => '-s' }.freeze
      ConsumeStdout = true # xsel would get stuck if we did not consume its stdout
      ConsumeStderr = true
    else
      raise Clipboard::ClipboardLoadError, "clipboard: Could not find required program xclip or xsel\n" \
            "On debian/ubuntu, you can install it with: sudo apt-get install xclip"
    end

    private
    # This method invokes a command, feed data to its stdin.
    # Based on read_stdout and read_stderr, the stdout and/or stderr will be consumed
    def send_stdin_consume_stdouterr(command, data_to_stdin, read_stdout = false, read_stderr = false)
      Open3.popen3(command){|stdin, stdout, stderr, wait_thr|
        thread_stdout_consumer = nil
        thread_stderr_consumer = nil

        if read_stdout == true
          thread_stdout_consumer = Thread.new{
            begin
              while true
                stdout_data = stdout.read(1024)
                if stdout_data == nil
                  break
                end
              end
            rescue IOError
            end
          }
        end

        if read_stderr == true
          thread_stderr_consumer = Thread.new{
            begin
              while true
                stderr_data = stderr.read(1024)
                if stderr_data == nil
                  break
                end
              end
            rescue IOError
            end
          }
        end

        begin
          stdin.write(data_to_stdin)
          stdin.close()
        rescue Errno::EPIPE
        end

        if wait_thr.value.exitstatus != 0
          raise RuntimeError, "Error writing clipboard"
        end

        if thread_stdout_consumer != nil
          thread_stdout_consumer.join
        end
        if thread_stderr_consumer != nil
          thread_stderr_consumer.join
        end
      }
      return
    end

    public
    def paste(which = nil)
      if !which || !CLIPBOARDS.include?(which.to_s.downcase)
        which = CLIPBOARDS.first
      end
      `#{ReadCommand} #{Selection[which.to_s.downcase]} 2> /dev/null`
    end

    def clear
      copy ''
    end

    def copy(data)
      CLIPBOARDS.each{|which|
        send_stdin_consume_stdouterr("#{WriteCommand} #{Selection[which.to_s.downcase]}", data, ConsumeStdout, ConsumeStderr)
      }
      return paste()
    end
  end
end

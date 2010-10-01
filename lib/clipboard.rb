require 'zucker/os'
require 'zucker/alias_for'
require 'stringio'

require File.expand_path '../../version', __FILE__

  def capture_stderr
    capture = StringIO.new
    restore, $stderr = $stderr, capture
    yield
    $stderr = restore
    capture.string
  end

class << Clipboard ||= Module.new
  case # OS
  when OS.linux? || OS.mac? || OS.bsd? || OS.posix?
    require 'open3'

    if OS.mac?
      WriteCommand = 'pbcopy'
      ReadCommand  = 'pbpaste'
    else # linuX
      WriteCommand = 'xclip'
      ReadCommand  = 'xclip -o'

      # catch dependency errors
      Open3.popen3( "xclip -version" ){ |_, _, error|
        unless error.read  =~ /^xclip version/
          raise "clipboard -\n" + 
                "Could not find required prgram xclip\n" + 
                "You can install it (on debian/ubuntu) with sudo apt-get install xclip"
        end
      }
    end

    def write(data)
      Open3.popen3( WriteCommand ){ |input, _, _|
        input << data
      }
      read # or true or nil?
    end

    def read
      %x[#{ ReadCommand }]
    end

    def clear
      write ''
    end
  when OS.windows?
    begin
      require 'win32/clipboard'
    rescue LoadError
      raise "clipboard -\n" +
            "Could not load the required win32-clipboard gem\n"
            "You can install it with gem install win32-clipboard"
    end

    def write(data)
      Win32::Clipboard.set_data( data )
      Win32::Clipboard.data
    end

    def read
      Win32::Clipboard.data
    end

    def clear
      Win32::Clipboard.empty
      Win32::Clipboard.data
    end
  end#case

  alias_for :write, :copy
  alias_for :read,  :paste

#  private

  def capture_stdout
      capture = StringIO.new
        restore, $stdout = $stdout, capture
          yield
            $stdout = restore
              capture.string
  end

end

# J-_-L

require 'zucker/os'
require 'zucker/alias_for'

require File.expand_path '../../version', __FILE__

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
    end

    def write(data)
      Open3.popen3( WriteCommand ){ |input, _, _|  input << data }
      read # or true or nil?
    end

    def read
      %x[#{ ReadCommand }]
    end

    def clear
      write ''
    end
  when OS.windows?
    require 'win32/clipboard'

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
end

# J-_-L

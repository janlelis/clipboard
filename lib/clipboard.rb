require 'zucker/os'
require 'zucker/alias_for'
require 'stringio'
require File.expand_path '../../version', __FILE__

module Clipboard
end
class << Clipboard
  case # OS
  when OS.linux? || OS.mac? || OS.bsd? #|| OS.posix?
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

    def read
      %x[#{ ReadCommand }]
    end

    def clear
      write ''
    end
  when OS.windows? # inspired by segment7.net and http://www.codeproject.com/KB/clipboard/archerclipboard1.aspx
    WriteCommand = 'clip'
    require 'Win32API'
  CF_TEXT = 1

    def read # does not work on 1.9, has probably something to do with utf8 strings ?
    data = ""
      if 0 != @open[ 0 ]
      hclip = @get[ CF_TEXT ]
        if 0 != hclip
        if 0 != data = @lock[ hclip ]
            @unlock[            hclip ]
        end
    end
        @close[]
    end
      data || ""
    end

    def clear
      @open[0]
      @empty[]
      @close[]
      read
    end

  end#case OS

   def write(data)
      IO.popen( WriteCommand, 'w' ){ |input| input << data }
      read # or true or nil?
    end

  
  # handier aliases
  alias_for :write, :copy
  alias_for :read,  :paste
end

module Clipboard
    # init api handlers
  if OS.windows?
    @open   = Win32API.new("user32", "OpenClipboard",['L'],'L')
    @close  = Win32API.new("user32", "CloseClipboard",[],'L')
    @empty  = Win32API.new("user32", "EmptyClipboard",[],'L')
    @get    = Win32API.new("user32", "GetClipboardData", ['L'], 'L')
    @lock   = Win32API.new("kernel32", "GlobalLock", ['L'], 'P')
    @unlock = Win32API.new("kernel32", "GlobalUnlock", ['L'], 'L')
    instance_variables.each{ |handler|
      instance_variable_get(handler).instance_eval do
        alias [] call
      end
    }
end
end

# J-_-L

def cp(o='jammi')
  Clipboard.copy o
  end
  
  def ps
    Clipboard.paste
  end
  
  def lll
  3000.times{|i|p i;ps;cp}
  end

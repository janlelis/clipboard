require 'zucker/os'
require 'zucker/alias_for'
require 'stringio'
require File.expand_path '../../version', __FILE__

module Clipboard
  if OS.windows?
    WriteCommands = ['clip']
    CF_TEXT = 1

    require 'Win32API'
    # init api handlers
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

    # paste & clear
    # inspired by segment7.net and http://www.codeproject.com/KB/clipboard/archerclipboard1.aspx
    # does not work on 1.9, has probably something to do with utf8 strings ?
    def self.paste(_=nil)
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

    def self.clear
      @open[0]
      @empty[]
      @close[]
      paste
    end
  else #non-windows
    require 'open3'

    if OS.mac?
      WriteCommands = ['pbcopy']
      ReadCommand  = 'pbpaste'
    else # linuX
      Clipboards   = %w[clipboard primary secondary]
      WriteCommands = Clipboards.map{|cb| 'xclip -selection ' + cb }
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

    def self.paste(which = nil)
      selection_string = if Clipboards.include?(which.to_s)
        " -selection #{which}"
      else
        ''
      end
      %x[#{ ReadCommand + selection_string }]
    end

    def self.clear
      copy ''
    end
  end

  def self.copy(data)
    WriteCommands.each{ |cmd|
      IO.popen( cmd, 'w' ){ |input| input << data }
    }
    paste
  end
end

# J-_-L

require 'zucker/os'
require 'zucker/version'

require File.expand_path '../../version', __FILE__

module Clipboard
  extend self

  if OS.windows?
    CF_TEXT = 1
    CF_UNICODETEXT = 13
    GMEM_MOVEABLE = 2

    # get ffi function handlers
    require 'ffi'

    module User32
      extend FFI::Library
      ffi_lib "user32"
      ffi_convention :stdcall

      attach_function :open,  :OpenClipboard,    [ :long ], :long
      attach_function :close, :CloseClipboard,   [       ], :long
      attach_function :empty, :EmptyClipboard,   [       ], :long
      attach_function :get,   :GetClipboardData, [ :long ], :long
      attach_function :set,   :SetClipboardData, [ :long, :long ], :long
    end

    module Kernel32
      extend FFI::Library
      ffi_lib 'kernel32'
      ffi_convention :stdcall
  
      attach_function :lock,   :GlobalLock,   [ :long ], :pointer
      attach_function :unlock, :GlobalUnlock, [ :long ], :long
      attach_function :alloc,  :GlobalAlloc,  [ :long, :long ], :long
    end
   
    # see http://www.codeproject.com/KB/clipboard/archerclipboard1.aspx
    def paste(_=nil)
      ret = ""
        if 0 != User32.open( 0 )
          hclip = User32.get( CF_UNICODETEXT )
          if hclip && 0 != hclip
            pointer_to_data = Kernel32.lock( hclip )
            data = ""
            # Windows Unicode is ended by to null bytes, so get the whole string
            current_byte = 0
            until data.size >= 2 && data[-1].ord == 0 && data[-2].ord == 0
              data << pointer_to_data.get_bytes( current_byte, 1 )
              current_byte += 1
            end
            if RubyVersion >= 1.9
              ret = data.chop.force_encoding("UTF-16LE").encode(Encoding.default_external) # TODO catch bad encodings
            else # 1.8: fallback to simple CP850 encoding
              require 'iconv'
              utf8 = Iconv.iconv( "UTF-8", "UTF-16LE", data.chop)[0]
              ret = Iconv.iconv( "CP850", "UTF-8", utf8)[0]
            end
          if data && 0 != data
            Kernel32.unlock( hclip )
          end
        end
        User32.close( )
      end
      ret || ""
    end
 
    def clear
      if 0 != User32.open( 0 )
        User32.empty( )
        User32.close( )
      end
      paste
    end
    
    def copy(data_to_copy)
      if RubyVersion >= 1.9 && 0 != User32.open( 0 )
        User32.empty( )
        data = data_to_copy.encode("UTF-16LE") # TODO catch bad encodings
        data << 0 << 0
        handler = Kernel32.alloc( GMEM_MOVEABLE, data.bytesize )
        pointer_to_data = Kernel32.lock( handler )
        pointer_to_data.put_bytes( 0, data, 0, data.bytesize )
        Kernel32.unlock( handler )
        User32.set( CF_UNICODETEXT, handler )
        User32.close( )
      else # don't touch anything
        IO.popen( 'clip', 'w' ){ |input| input << data_to_copy } # depends on clip (available by default since Vista)
      end
      paste
    end
  else #non-windows
    require 'open3'

    if OS.mac?
      CLIPBOARDS    = []
      WriteCommands = ['pbcopy']
      ReadCommand  = 'pbpaste'
    else # linuX
      CLIPBOARDS   = %w[clipboard primary secondary]
      WriteCommands = CLIPBOARDS.map{|cb| 'xclip -selection ' + cb }
      ReadCommand  = 'xclip -o'

      # catch dependency errors
      begin
        Open3.popen3( "xclip -version" ){ |_, _, error|
          unless error.read  =~ /^xclip version/
            raise LoadError
          end
        }
      rescue Exception
        raise LoadError, "clipboard -\n" +
              "Could not find required prgram xclip\n" +
              "You can install it (on debian/ubuntu) with sudo apt-get install xclip"
      end
    end

    def paste(which = nil)
      selection_string = if CLIPBOARDS.include?(which.to_s)
        " -selection #{which}"
      else
        ''
      end
      %x[#{ ReadCommand + selection_string }]
    end

    def clear
      copy ''
    end

    def copy(data)
      WriteCommands.each{ |cmd|
        IO.popen( cmd, 'w' ){ |input| input << data }
      }
      paste
    end
  end
end

# J-_-L

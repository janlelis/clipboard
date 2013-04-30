require 'open3'

module Clipboard; end

module Clipboard::Windows
  extend self

  CF_TEXT = 1
  CF_UNICODETEXT = 13
  GMEM_MOVEABLE = 2

  # get ffi function handlers
  begin
    require 'ffi'
  rescue LoadError
    raise LoadError, 'Could not load the required ffi gem, install it with: gem install ffi'
  end

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
    attach_function :size,   :GlobalSize,   [ :long ], :long
    attach_function :alloc,  :GlobalAlloc,  [ :long, :long ], :long
  end

  # see http://www.codeproject.com/KB/clipboard/archerclipboard1.aspx
  def paste(_ = nil)
    ret = ""
      if 0 != User32.open( 0 )
        hclip = User32.get( CF_UNICODETEXT )
        if hclip && 0 != hclip
          pointer_to_data = Kernel32.lock( hclip )
          data = ""
          # Windows Unicode is ended by to null bytes, so get the whole string
          size = Kernel32.size( hclip )
          data << pointer_to_data.get_bytes( 0, size - 2 )
          if RUBY_VERSION >= '1.9'
            ret = data.force_encoding("UTF-16LE").encode(Encoding.default_external) # TODO catch bad encodings
          else # 1.8: fallback to simple CP850 encoding
            require 'iconv'
            utf8 = Iconv.iconv( "UTF-8", "UTF-16LE", data)[0]
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
    if ( RUBY_VERSION >= '1.9' ) && 0 != User32.open( 0 )
      User32.empty( )
      data = data_to_copy.encode("UTF-16LE") # TODO catch bad encodings
      data << 0
      handler = Kernel32.alloc( GMEM_MOVEABLE, data.bytesize )
      pointer_to_data = Kernel32.lock( handler )
      pointer_to_data.put_bytes( 0, data, 0, data.bytesize )
      Kernel32.unlock( handler )
      User32.set( CF_UNICODETEXT, handler )
      User32.close( )
    else # don't touch anything
      Open3.popen3( 'clip' ){ |input,_,_| input << data_to_copy } # depends on clip (available by default since Vista)
    end
    paste
  end
end

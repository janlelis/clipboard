# frozen_string_literal: true

require_relative 'utils'

module Clipboard
  module Windows
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
      ffi_lib 'user32'
      ffi_convention :stdcall

      attach_function :open,  :OpenClipboard,    [ :pointer ], :bool
      attach_function :close, :CloseClipboard,   [       ], :bool
      attach_function :empty, :EmptyClipboard,   [       ], :bool
      attach_function :get,   :GetClipboardData, [ :long ], :pointer
      attach_function :set,   :SetClipboardData, [ :long, :pointer ], :pointer
    end

    module Kernel32
      extend FFI::Library
      ffi_lib 'kernel32'
      ffi_convention :stdcall

      attach_function :lock,   :GlobalLock,   [ :pointer ], :pointer
      attach_function :unlock, :GlobalUnlock, [ :pointer ], :bool
      attach_function :size,   :GlobalSize,   [ :pointer ], :long
      attach_function :alloc,  :GlobalAlloc,  [ :long, :long ], :pointer
    end

    # see http://www.codeproject.com/KB/clipboard/archerclipboard1.aspx
    def paste(_ = nil)
      return String.new unless User32.open(nil)

      hclip = User32.get( CF_UNICODETEXT )
      return String.new if hclip.null?

      pointer_to_data = Kernel32.lock( hclip )
      # Windows Unicode is ended by two null bytes, so get the whole string
      size = Kernel32.size( hclip )
      data = pointer_to_data.read_string( size - 2 )
      data.force_encoding(Encoding::UTF_16LE)
    ensure
      Kernel32.unlock(hclip) if hclip && !hclip.null?
      User32.close
    end

    def clear
      User32.empty if User32.open(nil)
      paste
    ensure
      User32.close
    end

    def copy(data_to_copy)
      if User32.open(nil)
        User32.empty
        data = data_to_copy.encode(Encoding::UTF_16LE) # TODO: catch bad encodings
        data << 0
        handler = Kernel32.alloc( GMEM_MOVEABLE, data.bytesize )
        pointer_to_data = Kernel32.lock( handler )
        begin
          pointer_to_data.write_string( data )
        ensure
          Kernel32.unlock( handler )
        end
        User32.set( CF_UNICODETEXT, handler )
        data.chop
      else # don't touch anything
        Utils.popen "clip", data_to_copy # depends on clip (available by default since Vista)
        paste
      end
    ensure
      User32.close
    end
  end
end

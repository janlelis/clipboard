require 'open3'

module Clipboard; end

module Clipboard::Linux
  extend self

  CLIPBOARDS   = %w[clipboard primary secondary]
  WriteCommands = CLIPBOARDS.map{|cb| 'xclip -selection ' + cb }
  ReadCommand  = 'xclip -o'

  #catch dependency errors
  if not `which xclip`
    raise Clipboard::ClipboardLoadError, "clipboard:\n" \
          "Could not find required program xclip\n" \
          "On debian/ubuntu, you can install it with: sudo apt-get install xclip"
  end

  def paste(which = nil)
    which ||= CLIPBOARDS.first
    `#{ReadCommand} -selection #{which}`
  end

  def clear
    copy ''
  end

  def copy(data)
    WriteCommands.each{ |cmd|
      Open3.popen3( cmd ){ |input,_,_| input << data }
    }
    paste
  end
end

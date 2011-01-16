require 'open3'

module Clipboard
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

  def paste(which = nil)
    which ||= CLIPBOARDS.first
    `#{ReadCommand} -selection #{which}`
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
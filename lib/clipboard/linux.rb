class Clipboard::Linux
  CLIPBOARDS   = %w[clipboard primary secondary]
  WriteCommands = CLIPBOARDS.map{|cb| 'xclip -selection ' + cb }
  ReadCommand  = 'xclip -o'

  # catch dependency errors
  if `which xclip`.empty?
    raise LoadError, "clipboard:\n" +
          "Could not find required prgram xclip\n" +
          "On debian/ubuntu, you can install it with: sudo apt-get install xclip"
  end

  def self.paste(which = nil)
    which ||= CLIPBOARDS.first
    `#{ReadCommand} -selection #{which}`
  end

  def self.clear
    copy ' ' # impossible to copy nothing ?
  end

  def self.copy(data)
    WriteCommands.each{ |cmd|
      IO.popen( cmd, 'w' ){ |input| input << data }
    }
    paste
  end
end

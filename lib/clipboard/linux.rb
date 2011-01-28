require 'open3'

module Clipboard; end

module Clipboard::Linux
  extend self

  CLIPBOARDS   = %w[clipboard primary secondary]

  # check which backend to use
  if !`which xclip`.empty?
    WriteCommand = 'xclip'
    ReadCommand  = 'xclip -o'
    Selection    = proc{|x| "-selection #{x}"}
  elsif !`which xsel`.empty?
    WriteCommand = 'xsel'
    ReadCommand  = 'xsel -o'
    Selection    = {'clipboard' => '-b', 'primary' => '-p', 'secondary' => '-s'}
  else
    raise Clipboard::ClipboardLoadError, "clipboard:\n" \
          "Could not find required program xclip (or xsel)\n" \
          "On debian/ubuntu, you can install it with: sudo apt-get install xclip"
  end

  def paste(which = nil)
    if !which || !CLIPBOARDS.include?(which.to_s.downcase)
      which = CLIPBOARDS.first
    end
    `#{ReadCommand} #{Selection[which.to_s.downcase]}`
  end

  def clear
    copy ''
  end

  def copy(data)
    CLIPBOARDS.each{ |which|
      Open3.popen3( "#{WriteCommand} #{Selection[which.to_s.downcase]}" ){ |input,_,_| input << data }
    }
    paste
  end
end

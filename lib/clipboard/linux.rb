require 'open3'

module Clipboard; end

module Clipboard::Linux
  module_function

  CLIPBOARDS = %w(clipboard primary secondary)

  # check which backend to use
  if system('which xclip >/dev/null 2>&1')
    WRITE_COMMAND = 'xclip'
    READ_COMMAND  = 'xclip -o'
    SELECTION = proc { |x| "-selection #{x}" }
  elsif system('which xsel >/dev/null 2>&1')
    WRITE_COMMAND = 'xsel -i'
    READ_COMMAND  = 'xsel -o'
    SELECTION = { 'clipboard' => '-b', 'primary' => '-p', 'secondary' => '-s' }
  else
    raise Clipboard::ClipboardLoadError, "clipboard: Could not find required program xclip or xsel\n" \
          'On debian/ubuntu, you can install it with: sudo apt-get install xclip'
  end

  def paste(which = nil)
    if !which || !CLIPBOARDS.include?(which.to_s.downcase)
      which = CLIPBOARDS.first
    end
    `#{READ_COMMAND} #{SELECTION[which.to_s.downcase]}`
  end

  def clear
    copy ''
  end

  def copy(data)
    CLIPBOARDS.each{ |which|
      Open3.popen3("#{WRITE_COMMAND} #{SELECTION[which.to_s.downcase]}") { |input, _, _| input << data }
    }
    paste
  end
end

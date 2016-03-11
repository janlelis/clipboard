require 'open3'

module Clipboard; end

module Clipboard::Cygwin
  extend self

  def paste(_ = nil)
    print File.read('/dev/clipboard')
  end

  def copy(data)
    Open3.popen3('/dev/clipboard'){ |input,_,_| input << data }
    paste
  end

  def clear
    copy ''
  end
end

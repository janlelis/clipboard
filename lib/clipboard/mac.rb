module Clipboard
  def self.paste(_=nil)
    `pbpaste`
  end

  def self.copy(data)
    IO.popen('pbcopy', 'w'){|input| input << data }
    paste
  end

  def clear
    copy ''
  end
end

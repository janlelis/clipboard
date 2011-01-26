class Clipboard::File
  FILE = File.expand_path("~/.clipboard")

  def self.copy(text)
    File.open(FILE,'w'){|f| f.write(text) }
    text
  end

  def self.paste(_=nil)
    File.read(FILE) rescue ''
  end

  def self.clear
    copy('')
  end
end
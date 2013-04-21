module Clipboard; end

module Clipboard::File
  extend self

  FILE = File.expand_path("~/.clipboard")

  def copy(text)
    File.open(FILE, 'w', 0600) { |f| f.write(text) } rescue ''
    paste
  end

  def paste(_ = nil)
    File.read(FILE) rescue ''
  end

  def clear
    copy ''
  end
end

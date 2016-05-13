module Clipboard; end

module Clipboard::File
  module_function

  FILE = File.expand_path('~/.clipboard')

  def copy(text)
    begin
      File.open(FILE, 'w', 0600) { |f| f.write(text) }
    rescue
      ''
    end
    paste
  end

  def paste(_ = nil)
    File.read(FILE)
  rescue
    ''
  end

  def clear
    copy ''
  end
end

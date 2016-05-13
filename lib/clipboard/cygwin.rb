module Clipboard; end

module Clipboard::Cygwin
  module_function

  def paste(_ = nil)
    File.read('/dev/clipboard')
  end

  def copy(data)
    File.open('/dev/clipboard', 'w') { |f| f.write(data) }
    paste
  end

  def clear
    copy ''
  end
end

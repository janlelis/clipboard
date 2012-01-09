module Clipboard; end

# Basic java clipboard access (jruby). No fun to use on X.
module Clipboard::Java
  extend self

  FLAVOR = ::Java::JavaAwtDatatransfer::DataFlavor.stringFlavor

  def copy(text)
    selection_string = ::Java::JavaAwtDatatransfer::StringSelection.new text
    ::Java::JavaAwt::Toolkit.default_toolkit.system_clipboard.set_contents selection_string, nil
    paste
  end

  def paste(_ = nil)
    ::Java::JavaAwt::Toolkit.default_toolkit.system_clipboard.get_data(FLAVOR)
  rescue
    ''
  end

  def clear
    copy ''
  end
end

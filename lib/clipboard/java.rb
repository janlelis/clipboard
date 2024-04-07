# frozen_string_literal: true

require_relative "implementation"

module Clipboard
  # Basic java clipboard access (jruby). No fun to use on X.
  module Java
    include Implementation
    extend self

    FLAVOR = ::Java::JavaAwtDatatransfer::DataFlavor.stringFlavor

    def copy(data, **)
      selection_string = ::Java::JavaAwtDatatransfer::StringSelection.new data
      ::Java::JavaAwt::Toolkit.default_toolkit.system_clipboard.set_contents selection_string, nil

      true
    end

    def paste(_ = nil, **)
      ::Java::JavaAwt::Toolkit.default_toolkit.system_clipboard.get_data(FLAVOR)
    rescue
      ''
    end
  end
end

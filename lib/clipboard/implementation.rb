# frozen_string_literal: true

module Clipboard
  module Implementation
    extend self

    # Implement paste
    # Should take an optional argument
    def paste(_clipboard_name = nil)
      raise NotImplementedError, "pasting not supported by this implementation, try another"
    end

    # Takes the data to copy as argument
    # Should return true
    def copy(_data)
      raise NotImplementedError, "copying not supported by this implementation, try another"
    end

    # Can be used to add a native clear implementation
    # Should return true
    def clear
      copy ''

      true
    end
  end
end

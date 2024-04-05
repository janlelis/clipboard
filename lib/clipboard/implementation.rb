# frozen_string_literal: true

module Clipboard
  module Implementation
    extend self

    def paste(_clipboard_name = nil)
      raise NotImplementedError, "paste not supported by implementation"
    end

    def copy(_data)
      raise NotImplementedError, "copy not supported by implementation"
    end

    def clear
      copy ''
    end
  end
end

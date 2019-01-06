# frozen_string_literal: true

module Clipboard
  module Cygwin
    extend self

    def paste(_ = nil)
      ::File.read("/dev/clipboard")
    end

    def copy(data)
      ::File.open("/dev/clipboard", "w"){ |f| f.write(data) }
      paste
    end

    def clear
      copy ''
    end
  end
end

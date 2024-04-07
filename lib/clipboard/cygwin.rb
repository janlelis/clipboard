# frozen_string_literal: true

require_relative "implementation"

module Clipboard
  module Cygwin
    include Implementation
    extend self

    def paste(_ = nil, **)
      ::File.read("/dev/clipboard")
    end

    def copy(data, **)
      ::File.open("/dev/clipboard", "w"){ |f| f.write(data) }

      true
    end
  end
end

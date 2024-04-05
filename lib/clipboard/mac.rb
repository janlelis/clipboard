# frozen_string_literal: true

require_relative "implementation"
require_relative "utils"

module Clipboard
  module Mac
    include Implementation
    extend self

    def paste(_ = nil)
      `pbpaste`
    end

    def copy(data)
      Utils.popen "pbcopy", data

      true
    end
  end
end

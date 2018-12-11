# frozen_string_literal: true

require_relative "utils"

module Clipboard
  module Mac
    extend self

    def paste(_ = nil)
      `pbpaste`
    end

    def copy(data)
      Utils.popen "pbcopy", data
      paste
    end

    def clear
      copy ''
    end
  end
end

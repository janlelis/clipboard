# frozen_string_literal: true

require_relative "utils"

module Clipboard
  module LinuxWayland
    extend self

    def paste(_ = nil)
      `wl-paste`
    end

    def copy(data)
      Utils.popen "wl-copy", data
      paste
    end

    def clear
      `wl-copy -c`
    end
  end
end

# frozen_string_literal: true

require_relative "utils"

module Clipboard
  module LinuxWayland
    extend self

    WRITE_COMMAND = "wl-copy"
    READ_COMMAND = "wl-paste"

    if !Utils.executable_installed?(WRITE_COMMAND)
      raise Clipboard::ClipboardLoadError, "clipboard: Could not find required program wl-copy\n" \
                                           "Please install it or try a different implementation"
    end

    def paste(_ = nil)
      `#{READ_COMMAND}`
    end

    def copy(data)
      Utils.popen WRITE_COMMAND, data
      paste
    end

    def clear
      `#{WRITE_COMMAND} -c`
    end
  end
end

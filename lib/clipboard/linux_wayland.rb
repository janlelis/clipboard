# frozen_string_literal: true

require_relative "implementation"
require_relative "utils"

module Clipboard
  module LinuxWayland
    include Implementation
    extend self

    TEST_COMMAND  = "wl-copy"
    WRITE_COMMAND = "wl-copy --type text/plain"
    READ_COMMAND  = "wl-paste --type text/plain --no-newline"

    if !Utils.executable_installed?(TEST_COMMAND)
      raise Clipboard::ClipboardLoadError, "clipboard: Could not find required program wl-copy\n" \
                                           "Please install it or try a different implementation"
    end

    def paste(might_select_primary_clipboard = nil, **)
      if might_select_primary_clipboard == "primary"
        `#{READ_COMMAND} --primary`
      else
        `#{READ_COMMAND}`
      end
    end

    def copy(data, **)
      Utils.popen WRITE_COMMAND, data

      true
    end

    def clear(**)
      `#{WRITE_COMMAND} --clear`

      true
    end
  end
end

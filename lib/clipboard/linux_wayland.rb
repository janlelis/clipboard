# frozen_string_literal: true

require_relative "implementation"
require_relative "utils"

module Clipboard
  module LinuxWayland
    include Implementation
    extend self

    CLIPBOARDS = %w[clipboard primary].freeze

    TEST_COMMAND  = "wl-copy"
    WRITE_COMMAND = "wl-copy --type text/plain"
    READ_COMMAND  = "wl-paste --type text/plain --no-newline"

    if !Utils.executable_installed?(TEST_COMMAND)
      raise Clipboard::ClipboardLoadError, "clipboard: Could not find required program wl-copy\n" \
                                           "Please install it or try a different implementation"
    end

    def paste(selection = nil, **)
      primary_flag = selection == "primary" ? " --primary" : ""
      `#{READ_COMMAND}#{primary_flag}`
    end

    def copy(data, clipboard: "all")
      selections = clipboard.to_s == "all" ? CLIPBOARDS : [clipboard]
      selections.each{ |selection|
        primary_flag = selection == "primary" ? " --primary" : ""
        Utils.popen("#{WRITE_COMMAND}#{primary_flag}", data)
      }

      true
    end

    def clear(clipboard: "all")
      selections = clipboard.to_s == "all" ? CLIPBOARDS : [clipboard]
      selections.each{ |selection|
        primary_flag = selection.to_s == "primary" ? " --primary" : ""
        `#{WRITE_COMMAND}#{primary_flag} --clear`
      }

      true
    end
  end
end

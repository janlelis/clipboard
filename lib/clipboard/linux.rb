# frozen_string_literal: true

require_relative "implementation"
require_relative "utils"

module Clipboard
  module Linux
    include Implementation
    extend self

    CLIPBOARDS = %w[clipboard primary secondary].freeze

    # First check for xsel, fallback to xclip
    if Utils.executable_installed? "xsel"
      WRITE_COMMAND = 'xsel -i'
      READ_COMMAND = 'xsel -o'
      READ_OUTPUT_STREAM = true
      SELECTION = {
        'clipboard' => '--clipboard',
        'primary' => '--primary',
        'secondary' => '--secondary'
      }.freeze

    elsif Utils.executable_installed? "xclip"
      WRITE_COMMAND = 'xclip'
      READ_COMMAND = 'xclip -o'
      READ_OUTPUT_STREAM = false
      SELECTION = proc{ |x|
        "-selection #{x}"
      }.freeze

    else
      raise Clipboard::ClipboardLoadError,
            "clipboard: Could not find required program xsl or xclip (X11) or wl-clipboard (Wayland)"
    end

    def paste(which = nil, clipboard: "clipboard")
      selection = which || clipboard
      raise ArgumentError, "unknown clipboard selection" unless CLIPBOARDS.include?(selection)

      `#{READ_COMMAND} #{SELECTION[selection]} 2> /dev/null`
    end

    def copy(data, clipboard: "all")
      selections = clipboard.to_s == "all" ? CLIPBOARDS : [clipboard]
      selections.each{ |selection|
        raise ArgumentError, "unknown clipboard selection" unless CLIPBOARDS.include?(selection)

        Utils.popen "#{WRITE_COMMAND} #{SELECTION[selection]}", data, READ_OUTPUT_STREAM
      }

      true
    end
  end
end

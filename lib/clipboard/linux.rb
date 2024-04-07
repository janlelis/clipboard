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
      raise Clipboard::ClipboardLoadError, "clipboard: Could not find required program xclip or xsel\n" \
                                           "On debian/ubuntu, you can install it with: sudo apt-get install xsel\n" \
                                           "If your system is Wayland-based, please install wl-clipboard"
    end

    def paste(which = nil, **)
      if !which || !CLIPBOARDS.include?(which_normalized = which.to_s.downcase)
        which_normalized = CLIPBOARDS.first
      end

      `#{READ_COMMAND} #{SELECTION[which_normalized]} 2> /dev/null`
    end

    def copy(data, clipboard: "all")
      selections = clipboard.to_s == "all" ? CLIPBOARDS : [clipboard]
      selections.each{ |selection|
        Utils.popen "#{WRITE_COMMAND} #{SELECTION[selection]}", data, READ_OUTPUT_STREAM
      }

      true
    end
  end
end

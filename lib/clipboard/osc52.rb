# frozen_string_literal: true

require_relative "implementation"

module Clipboard
  module Osc52
    include Implementation
    extend self

    CLIPBOARDS = %w[clipboard primary].freeze
    OSC52 = "]52;%<selection_option>s;%<data_base64>s"

    def copy(data, clipboard: "all")
      selections = clipboard.to_s == "all" ? CLIPBOARDS : [clipboard]
      selections.each{ |selection|
        raise ArgumentError, "unknown clipboard selection" unless CLIPBOARDS.include?(selection)

        print OSC52 % {
          selection_option: selection == "primary" ? "p" : "c",
          data_base64: [data].pack("m0"),
        }
      }

      true
    end

    def clear(clipboard: "all")
      selections = clipboard.to_s == "all" ? CLIPBOARDS : [clipboard]
      selections.each{ |selection|
        raise ArgumentError, "unknown clipboard selection" unless CLIPBOARDS.include?(selection)

        print OSC52 % {
          selection_option: selection == "primary" ? "p" : "c",
          data_base64: ?! # anything non-base64 / question mark clears
        }
      }

      true
    end
  end
end

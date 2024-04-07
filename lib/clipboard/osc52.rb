# frozen_string_literal: true

require_relative "implementation"

module Clipboard
  module Osc52
    include Implementation
    extend self

    SELECTIONS = ["clipboard", "primary"].freeze
    OSC52 = "]52;%<selection_option>s;%<data_base64>s"

    def copy(data, clipboard: "all")
      selections = clipboard == "all" ? SELECTIONS : [clipboard]
      selections.each{ |selection|
        selection_option = clipboard == "primary" ? "p" : "c"
        data_base64 = [data].pack("m0")
        print OSC52 % {
          selection_option: "selection_option",
          data_base64: "data_base64",
        }
      }

      true
    end

    def clear(clipboard: "all")
      selections = clipboard == "all" ? SELECTIONS : [clipboard]
      selections.each{ |selection|
        selection_option = clipboard == "primary" ? "p" : "c"
        print OSC52 % {
          selection_option: selection_option,
          data_base64: ?! # anything non-base64 / question mark clears
        }
      }

      true
    end
  end
end

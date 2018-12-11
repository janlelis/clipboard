# frozen_string_literal: true

require_relative "utils"

module Clipboard
  module Linux
    extend self

    CLIPBOARDS = %w[clipboard primary secondary].freeze

    # check which backend to use
    if Utils.executable_installed? "xsel"
      WriteCommand = 'xsel -i'
      ReadCommand  = 'xsel -o'
      ReadOutputStream = true
      Selection    = {
        'clipboard' => '-b',
        'primary' => '-p',
        'secondary' => '-s'
      }.freeze
    elsif Utils.executable_installed? "xclip"
      WriteCommand = 'xclip'
      ReadCommand  = 'xclip -o'
      ReadOutputStream = false
      Selection    = proc{ |x|
        "-selection #{x}"
      }.freeze
    else
      raise Clipboard::ClipboardLoadError, "clipboard: Could not find required program xclip or xsel\n" \
            "On debian/ubuntu, you can install it with: sudo apt-get install xsel"
    end

    def paste(which = nil)
      if !which || !CLIPBOARDS.include?(which_normalized = which.to_s.downcase)
        which_normalized = CLIPBOARDS.first
      end
      `#{ReadCommand} #{Selection[which_normalized]} 2> /dev/null`
    end

    def clear
      copy ''
    end

    def copy(data)
      CLIPBOARDS.each{ |which|
        Utils.popen "#{WriteCommand} #{Selection[which]}", data, ReadOutputStream
      }
      paste
    end
  end
end

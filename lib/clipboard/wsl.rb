# frozen_string_literal: true

require_relative "utils"

module Clipboard
  module Wsl
    extend self

    def paste(_ = nil)
      `powershell.exe -Command Get-Clipboard`
    end

    def copy(data)
      Utils.popen "clip.exe", data
      paste
    end

    def clear
      copy ''
    end
  end
end

# frozen_string_literal: true

require_relative "implementation"
require_relative "utils"

module Clipboard
  module Wsl
    include Implementation
    extend self

    def paste(_ = nil)
      `powershell.exe -Command Get-Clipboard`
    end

    def copy(data)
      Utils.popen "clip.exe", data
      paste
    end
  end
end

require 'open3'

module Clipboard
  module Wsl
    extend self

    def paste(_ = nil)
      `powershell.exe -Command Get-Clipboard`
    end

    def copy(data)
      Open3.popen3( 'clip.exe' ){ |input, _, _| input << data }
      paste
    end

    def clear
      copy ''
    end
  end
end

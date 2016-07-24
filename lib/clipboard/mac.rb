require 'open3'

module Clipboard
  module Mac
    extend self

    def paste(_ = nil)
      `pbpaste`
    end

    def copy(data)
      Open3.popen3( 'pbcopy' ){ |input, _, _| input << data }
      paste
    end

    def clear
      copy ''
    end
  end
end

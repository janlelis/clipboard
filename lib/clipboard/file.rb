# frozen_string_literal: true

require_relative "implementation"

module Clipboard
  module File
    include Implementation
    extend self

    FILE = ::File.expand_path("~/.clipboard")

    def copy(text)
      ::File.open(FILE, 'w', 0o0600) { |f| f.write(text) } rescue ''
      paste
    end

    def paste(_ = nil)
      ::File.read(FILE) rescue ''
    end
  end
end

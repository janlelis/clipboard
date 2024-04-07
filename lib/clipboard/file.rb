# frozen_string_literal: true

require_relative "implementation"

module Clipboard
  module File
    include Implementation
    extend self

    FILE = ::File.expand_path("~/.clipboard")

    def copy(data, **)
      ::File.open(FILE, 'w', 0o0600) { |f| f.write(data) } rescue ''

      true
    end

    def paste(_ = nil, **)
      ::File.read(FILE) rescue ''
    end
  end
end

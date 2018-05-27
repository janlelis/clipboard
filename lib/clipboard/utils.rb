module Clipboard
  module Utils
    extend self

    def executable_installed?(cmd)
      ENV['PATH'].split(::File::PATH_SEPARATOR).any? do |path|
        ::File.executable?(::File.join(path, cmd))
      end
    end
  end
end

module Clipboard; end
module Clipboard::String
  refine String do
    def copy
      ::Clipboard.copy(self)
    end
  end
end

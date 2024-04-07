# frozen_string_literal: true

require_relative "implementation"

module Clipboard
  # Ruby-Gnome2 based implementation
  # Requires either the gtk3 or the gtk2 gem
  module Gtk
    include Implementation
    extend self

    CLIPBOARDS = %w[clipboard primary secondary].freeze

    unless defined? ::Gtk
      begin
        require 'gtk3'
      rescue LoadError
        begin
          require 'gtk2'
        rescue LoadError
          raise LoadError, 'Could not load the required gtk3 or gtk2 gem, please install it with: gem install gtk3'
        end
      end
    end

    def paste(which = nil, **)
      if !which || !CLIPBOARDS.include?(which.to_s.downcase)
        which = CLIPBOARDS.first
      end

      ::Gtk::Clipboard.get(
        Gdk::Selection.const_get(which.to_s.upcase)
      ).wait_for_text || ""
    end

    def copy(data, clipboard: "all")
      selections = clipboard.to_s == "all" ? CLIPBOARDS : [clipboard]
      selections.each{ |selection|
        ::Gtk::Clipboard.get(Gdk::Selection.const_get(selection.to_s.upcase)).set_text(data).store
      }

      true
    end

    def clear(clipboard: "all")
      selections = clipboard.to_s == "all" ? CLIPBOARDS : [clipboard]
      selections.each{ |selection|
        ::Gtk::Clipboard.get(Gdk::Selection.const_get(selection.to_s.upcase)).clear
      }

      true
    end
  end
end

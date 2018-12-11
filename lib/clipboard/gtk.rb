# frozen_string_literal: true

# Ruby-Gnome2 based implementation
# Requires either the gtk3 or the gtk2 gem

module Clipboard
  module Gtk
    extend self

    CLIPBOARDS = %w[CLIPBOARD PRIMARY SECONDARY].freeze

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

    def copy(text)
      CLIPBOARDS.each{ |which|
        ::Gtk::Clipboard.get(Gdk::Selection.const_get(which)).set_text(text).store
      }
      paste
    end

    def paste(which = nil)
      if !which || !CLIPBOARDS.include?(which_normalized = which.to_s.upcase)
        which_normalized = CLIPBOARDS.first
      end

      ::Gtk::Clipboard.get(
        Gdk::Selection.const_get(which_normalized)
      ).wait_for_text || ""
    end

    def clear
      CLIPBOARDS.each{ |which|
        ::Gtk::Clipboard.get(Gdk::Selection.const_get(which)).clear
      }
    end
  end
end

# frozen_string_literal: true

require_relative "spec_helper"

require "rbconfig"

if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
  require 'clipboard/windows'

  describe "Clipboard::Windows" do
    before :all do
      Clipboard.implementation = Clipboard::Windows
    end

    it "can copy & paste" do
      expect( Clipboard.copy('example') ).to eq true
      expect( Clipboard.paste ).to eq 'example'.encode("UTF-16LE")
    end

    it "can clear" do
      expect( Clipboard.copy('example') ).to eq true
      expect( Clipboard.paste ).to eq 'example'.encode("UTF-16LE")
      Clipboard.clear
      expect( Clipboard.paste ).to eq ''
    end
  end
end

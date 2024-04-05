# frozen_string_literal: true

require_relative "spec_helper"

require "rbconfig"

if RbConfig::CONFIG['host_os'] =~ /mac|darwin/
  require 'clipboard/mac'

  describe "Clipboard::Mac" do
    before :all do
      Clipboard.implementation = Clipboard::Mac
    end

    it "can copy & paste" do
      expect( Clipboard.copy('example') ).to eq true
      expect( Clipboard.paste ).to eq 'example'
    end

    it "can clear" do
      expect( Clipboard.copy('example') ).to eq true
      expect( Clipboard.paste ).to eq 'example'
      Clipboard.clear
      expect( Clipboard.paste ).to eq ''
    end
  end
end

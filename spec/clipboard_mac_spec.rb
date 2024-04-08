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
      Clipboard.copy('123mac')
      expect( Clipboard.paste ).to eq '123mac'
    end

    it "can clear" do
      Clipboard.copy('123mac')
      expect( Clipboard.paste ).to eq '123mac'
      Clipboard.clear
      expect( Clipboard.paste ).to eq ''
    end
  end
end

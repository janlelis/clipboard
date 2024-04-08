# frozen_string_literal: true

require_relative "spec_helper"

require "rbconfig"

if RbConfig::CONFIG['host_os'] =~ /linux|bsd/
  require 'clipboard/linux'

  describe "Clipboard::Linux" do
    before :all do
      Clipboard.implementation = Clipboard::Linux
    end

    it "can copy & paste" do
      Clipboard.copy('123linux')
      expect( Clipboard.paste ).to eq '123linux'
    end

    it "can clear" do
      Clipboard.copy('123linux')
      expect( Clipboard.paste ).to eq '123linux'
      Clipboard.clear
      expect( Clipboard.paste ).to eq ''
    end
  end
end

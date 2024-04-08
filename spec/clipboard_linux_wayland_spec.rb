# frozen_string_literal: true

require_relative "spec_helper"

require "rbconfig"

if RbConfig::CONFIG['host_os'] =~ /linux|bsd/ &&
   ENV["XDG_SESSION_TYPE"] == "wayland" &&
   Clipboard::Utils.executable_installed?("wl-copy")
  require 'clipboard/linux_wayland'

  describe "Clipboard::LinuxWayland" do
    before :all do
      Clipboard.implementation = Clipboard::LinuxWayland
    end

    it "can copy & paste" do
      Clipboard.copy('123wayland')
      expect( Clipboard.paste ).to eq '123wayland'
    end

    it "can clear" do
      Clipboard.copy('123wayland')
      expect( Clipboard.paste ).to eq '123wayland'
      Clipboard.clear
      expect( Clipboard.paste ).to eq ''
    end
  end
end

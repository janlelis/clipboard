# frozen_string_literal: true

require_relative "spec_helper"

if RUBY_ENGINE === "jruby"
  require 'clipboard/java'

  describe "Clipboard::Java" do
    before :all do
      Clipboard.implementation = Clipboard::Java
    end

    it "can copy & paste" do
      Clipboard.copy('example')
      expect( Clipboard.paste ).to eq 'example'
    end

    it "can clear" do
      Clipboard.copy('example')
      expect( Clipboard.paste ).to eq 'example'
      Clipboard.clear
      expect( Clipboard.paste ).to eq ''
    end
  end
end

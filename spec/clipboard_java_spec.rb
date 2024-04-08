# frozen_string_literal: true

require_relative "spec_helper"

if RUBY_ENGINE === "jruby"
  require 'clipboard/java'

  describe "Clipboard::Java" do
    before :all do
      Clipboard.implementation = Clipboard::Java
    end

    it "can copy & paste" do
      Clipboard.copy('123java')
      expect( Clipboard.paste ).to eq '123java'
    end

    it "can clear" do
      Clipboard.copy('123java')
      expect( Clipboard.paste ).to eq '123java'
      Clipboard.clear
      expect( Clipboard.paste ).to eq ''
    end
  end
end

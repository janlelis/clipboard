# frozen_string_literal: true

require_relative "spec_helper"

os_to_restore = RbConfig::CONFIG['host_os']

describe Clipboard do
  before do
    RbConfig::CONFIG['host_os'] = os_to_restore
    @is_windows = Clipboard.implementation.name == 'Clipboard::Windows'
  end

  let(:expected) { ->(text) { @is_windows ? text.encode(Encoding::UTF_16LE) : text } }

  it "can copy & paste" do
    text = "FOO\nBAR"
    Clipboard.copy(text)
    expect( Clipboard.paste.bytes ).to eq expected.(text).bytes
  end

  it "can copy & paste with multibyte char" do
    Encoding.default_external = 'utf-8'
    text = '日本語'
    Clipboard.copy(text)
    expect( Clipboard.paste ).to eq expected.(text)
  end

  it "returns true on copy" do
    text = 'xxx'
    expect( Clipboard.copy(text) ).to eq true
  end

  it "can clear" do
    Clipboard.copy('xxx')
    Clipboard.clear
    expect( Clipboard.paste ).to eq expected.('')
  end

  describe "when included" do
    class A
      include Clipboard
    end

    it "can copy & paste & clear" do
      a = A.new
      text = 'XXX'
      expect( a.send(:copy, text) ).to eq true
      expect( a.send(:paste) ).to eq expected.(text)
      a.send(:clear)
      expect( a.send(:paste) ).to eq expected.('')
    end
  end

  # See https://github.com/janlelis/clipboard/issues/32 by @orange-kao
  it "can copy more than 8192 bytes" do
    # first batch
    data1 = Random.new.bytes(2**14).unpack("H*").first
    Clipboard.copy(data1)
    data2 = Clipboard.paste

    expect(data2).to eq expected.(data1)

    # second batch
    data1 = Random.new.bytes(2**14).unpack("H*").first
    Clipboard.copy(data1)
    data2 = Clipboard.paste

    expect(data2).to eq expected.(data1)
  end

  describe :implementation do
    before do
      $VERBOSE = false
      Clipboard.implementation = nil
    end

    it "does not warn on normal detection" do
      if ( ENV["XDG_SESSION_TYPE"] != "wayland" && (system('which xclip >/dev/null 2>&1') || system('which xsel >/dev/null 2>&1') ) ) ||
         ( ENV["XDG_SESSION_TYPE"] == "wayland" && system('which wl-copy >/dev/null 2>&1') )
        expect( $stderr ).not_to receive(:puts)
      end
      Clipboard.implementation
    end

    it "warns when OS is unknown" do
      RbConfig::CONFIG['host_os'] = 'Fooo OS'
      expect( $stderr ).to receive(:puts)
      expect( Clipboard.implementation ).to eq Clipboard::File
    end

    it "does not warn when $VERBOSE is nil" do
      $VERBOSE = nil
      RbConfig::CONFIG['host_os'] = 'Fooo OS'
      expect( $stderr ).not_to receive(:puts)
      Clipboard.implementation
    end

    it "is possible to set implementation with snake-cased string" do
      module Clipboard::TestImplementation
      end
      Clipboard.implementation = "test_implementation"
      expect( Clipboard.implementation ).to eq Clipboard::TestImplementation
    end

    it "warns when unknown implementation name is given" do
      expect( $stderr ).to receive(:puts)
      Clipboard.implementation = "unknown"
      expect( Clipboard.implementation ).to eq Clipboard::File
    end
  end
end

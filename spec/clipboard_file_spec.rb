# frozen_string_literal: true

require_relative "spec_helper"

require 'clipboard/file'
require "fileutils"

describe 'Clipboard::File' do
  before :all do
    Clipboard.implementation = Clipboard::File
    cache = Clipboard::File::FILE
    FileUtils.rm_f cache
  end

  it "can paste with empty file" do
    expect( Clipboard.paste ).to eq ''
  end

  it "can copy & paste" do
    Clipboard.copy('123file')
    expect( Clipboard.paste ).to eq '123file'
  end

  it "can clear" do
    Clipboard.copy('123file')
    expect( Clipboard.paste ).to eq '123file'
    Clipboard.clear
    expect( Clipboard.paste ).to eq ''
  end
end

# frozen_string_literal: true

require_relative "spec_helper"

describe 'Clipboard::File' do
  before :all do
    Clipboard.implementation = Clipboard::File
    cache = Clipboard::File::FILE
    FileUtils.rm cache if File.exist?(cache)
  end

  it "can paste with empty file" do
    expect( Clipboard.paste ).to eq ''
  end

  it "can copy & paste" do
    expect( Clipboard.copy('xxx') ).to eq 'xxx'
    expect( Clipboard.paste ).to eq 'xxx'
  end

  it "can clear" do
    expect( Clipboard.copy('xxx') ).to eq 'xxx'
    Clipboard.clear
    expect( Clipboard.paste ).to eq ''
  end
end

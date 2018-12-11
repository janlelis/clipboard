require_relative 'spec_helper'

require "clipboard/linux"

describe Clipboard::Linux do
  # See https://github.com/janlelis/clipboard/issues/32 by @orange-kao
  it "can copy more than 8192 bytes" do
    # first batch
    data1 = Random.new.bytes(2**14).unpack("H*").first
    data2 = Clipboard.copy(data1)

    expect(data2).to eq data1

    # second batch
    data1 = Random.new.bytes(2**14).unpack("H*").first
    data2 = Clipboard.copy(data1)

    expect(data2).to eq data1
  end
end

require File.expand_path('spec/spec_helper')

describe Clipboard do
  it "has a VERSION" do
    Clipboard::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  it "can copy & paste" do
    Clipboard.copy("FOO\nBAR")
    Clipboard.paste.should == "FOO\nBAR"
  end

  it "returns data on copy" do
    Clipboard.copy('xxx').should == 'xxx'
  end

  it "can clear" do
    Clipboard.copy('xxx')
    Clipboard.clear
    Clipboard.paste.strip.should == ''
  end
end
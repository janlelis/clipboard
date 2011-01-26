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

  describe "when included" do
    class A
      include Clipboard
    end

    it "can copy & paste & clear" do
      a = A.new
      a.send(:copy, "XXX").should == 'XXX'
      a.send(:paste).should == "XXX"
      a.send(:clear)
      a.send(:paste).strip.should == ''
    end
  end

  describe :detect_os do
    it "raises when os is unknown" do
      RbConfig::CONFIG['host_os'] = 'Fooo OS'
      lambda{
        Clipboard.detect_os
      }.should raise_error
    end
  end
end
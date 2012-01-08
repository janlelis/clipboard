# Please note: cannot test, if it really accesses your platform clipboard.

require File.expand_path('spec/spec_helper')

$os = RbConfig::CONFIG['host_os']

describe Clipboard do
  before do
    RbConfig::CONFIG['host_os'] = $os
  end

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
    Clipboard.paste.should == ''
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
      a.send(:paste).should == ''
    end
  end

  describe 'Clipboard::File' do
    before :all do
      Clipboard.implementation = Clipboard::File
      cache = Clipboard::File::FILE
      FileUtils.rm cache if File.exist?(cache)
    end

    it "can paste with empty file" do
      Clipboard.paste.should == ''
    end

    it "can copy & paste" do
      Clipboard.copy('xxx').should == 'xxx'
      Clipboard.paste.should == 'xxx'
    end

    it "can clear" do
      Clipboard.copy('xxx').should == 'xxx'
      Clipboard.clear
      Clipboard.paste.should == ''
    end
  end

  describe :implementation do
    before do
      $VERBOSE = true
      Clipboard.implementation = nil
    end

    it "does not warn on normal detection" do
      $stderr.should_not_receive(:puts)
      Clipboard.implementation
    end

    it "warns when OS is unknown" do
      RbConfig::CONFIG['host_os'] = 'Fooo OS'
      $stderr.should_receive(:puts)
      Clipboard.implementation.should == Clipboard::File
    end

    it "does not warn when $VERBOSE is false" do
      $VERBOSE = false
      RbConfig::CONFIG['host_os'] = 'Fooo OS'
      $stderr.should_not_receive(:puts)
      Clipboard.implementation
    end
  end
end

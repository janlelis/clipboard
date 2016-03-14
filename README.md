# Ruby Clipboard [![version](https://badge.fury.io/rb/clipboard.svg)](https://badge.fury.io/rb/clipboard) [<img src="https://travis-ci.org/janlelis/clipboard.png" />](https://travis-ci.org/janlelis/clipboard)

Lets you access the clipboard on Linux, MacOS, Windows and Cygwin.

## Usage

* `Clipboard.copy`
* `Clipboard.paste`
* `Clipboard.clear`

## Setup

Add to `Gemfile`:

```ruby
gem 'clipboard'
gem 'ffi', :platforms => [:mswin, :mingw]
```

- **Linux**: You will need the `xclip` or `xsel` program. On debian/ubuntu
this is: `sudo apt-get install xclip`

## Remarks
### Multiple Clipboards

On Linux, you can choose from which clipboard you want to `paste` from by
passing it as an argumument. The default is CLIPBOARD.

`copy` copies to all clipboards in `Clipboard::Linux::CLIPBOARDS`.

### Windows Encoding

Windows uses [UTF-16LE](https://en.wikipedia.org/wiki/UTF-16) as its default
encoding, so pasted strings will always come in UTF-16LE. You can manually
convert them to your desired encoding (e.g. UTF-8) using the
[String#encode](ruby-doc.org/core-2.3.0/String.html#method-i-encode) method:

```ruby
Clipboard.paste.encode('UTF-8')
```

### SSH

To use the clipboard through ssh, you need to install `xauth` on your server
and connect via `ssh -X` or `ssh -Y`. Please note that some server settings
restrict this feature.

### Java

There is a Java implementation included (`Clipboard::Java`) as an option for
JRuby. On Linux, it always operates only on the CLIPBOARD clipboard.

### TODO

* Native support on X (don't depend on `xclip`/`xsel`) would be great

### blip

**blip** is a handy commandline wrapper that lets you quickly copy file
content to your clipboard: [blip](http://rubygems.org/gems/blip)!

### Copyright

Copyright (c) 2010-2016 Jan Lelis <http://janlelis.com> released under the MIT
license. Contributions by and thanks to Michael Grosser and [all the other
contributors!](https://github.com/janlelis/clipboard/graphs/contributors)

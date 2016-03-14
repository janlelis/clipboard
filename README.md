# Ruby Clipboard [<img src="https://travis-ci.org/janlelis/clipboard.png" />](https://travis-ci.org/janlelis/clipboard)

Lets you access the clipboard on Linux, MacOS or Windows.

### Usage

* `Clipboard.copy`
* `Clipboard.paste`
* `Clipboard.clear`

## Remarks
### Non-gem Requirements

* **Linux**: `xclip` or `xsel`, you can install it on debian/ubuntu with
  `sudo apt-get install xclip`

#### ffi Dependency

This gem depends on the **ffi** gem to support the Windows clipboard. Since
**ffi** requires native support, it cannot be installed on evevry platform and
is not a hard dependency. If you need Windows support, you will need to put
the **ffi** gem into your Gemfile.

#### Multiple Clipboards

On Linux, you can choose from which clipboard you want to `paste` by passing
it as an argumument. The default is CLIPBOARD.

`copy` copies to all clipboards in Clipboard::CLIPBOARDS.

#### Windows Encoding

Windows uses [UTF-16LE](https://en.wikipedia.org/wiki/UTF-16) as its default encoding, so pasted strings will always come in UTF-16LE. You can manually convert them to your desired encoding (e.g. UTF-8) using the [String#encode](ruby-doc.org/core-2.3.0/String.html#method-i-encode) method:

```ruby
Clipboard.paste.encode('UTF-8')
```

##### Very Old Rubies

If you paste with 1.8, it will fallback to CP850 encoding. Copying with 1.8
will fallback to the `clip` utility, which is installed by default since Vista

#### SSH

To use the clipboard through ssh, you need to install `xauth` on your server
and connect via `ssh -X` or `ssh -Y`. Please note that some server settings
restrict this feature.

#### Java

There is a Java implementation included (`Clipboard::Java`) as an option for
JRuby. However, on Linux, it always operates only on the CLIPBOARD clipboard.

### TODO

*   Don't depend on `xclip`/`xsel` (no plans to implement it, though)

### blip

**blip** is a handy commandline wrapper that lets you quickly copy file
content to your clipboard: [blip](http://rubygems.org/gems/blip)!

### Copyright
Copyright (c) 2010-2016 Jan Lelis <http://janlelis.com> released under the MIT
license. Contributions by and thanks to Michael Grosser and [all the other
contributors!](https://github.com/janlelis/clipboard/graphs/contributors)

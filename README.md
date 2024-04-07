# Clipboard Ruby Gem [![version](https://badge.fury.io/rb/clipboard.svg)](https://badge.fury.io/rb/clipboard) [![[ci]](https://github.com/janlelis/clipboard/workflows/Test/badge.svg)](https://github.com/janlelis/clipboard/actions?query=workflow%3ATest)

Lets you access the clipboard from everywhere. Currently supported platforms:

- Linux (X11)
- Linux (Wayland)
- MacOS
- Windows
- Cygwin (POSIX environment for Windows)
- WSL (Windows Subsystem for Linux)
- Gtk+ (Cross Platform Widget Toolkit)
- Java (on JRuby)
- *Experimental:* OSC52 (ANSI escape sequence) **only copying** - also see note below

Supported Rubies: **3.3**, **3.2**, **3.1**, **3.0**

Unsupported, but might still work: **2.X** (use clipboard gem version 1.x)

## Usage

* `Clipboard.copy` - Copies a string to system clipboard
* `Clipboard.paste` - Paste text contents from system clipboard as string
* `Clipboard.clear` - Empties the system clipboard

## Setup

Add the following lines to your `Gemfile`:

```ruby
gem "clipboard"
gem "ffi", :platforms => [:mswin, :mingw] # Required by Clipboard on Windows
```

- **Important note for Linux** users: The clipboard requires the *xsel* or the *xclip* command-line program (X11), or the *wl-copy* / *wl-paste* command-line programs (Wayland). On debian and ubuntu, *xsel* can be installed with: `sudo apt-get install xsel` and *wl-copy* / *wl-paste* with `sudo apt-get install wl-clipboard`.

## Clipboard Implementations

In most environments, the appropriate clipboard implementation can be detected automatically. If none is found, the gem will fallback to a file based one, which will just write to/read from `~/.clipboard` instead of the system clipboard.

You can check the implementation used with: `Clipboard.implementation`

### Alternative Clipboard Providers

There are more implementations included in this gem, which are not activated by default. You can opt-in to use them if you think they are a better fit for your application environment:

#### Java

Activate with: `Clipboard.implementation = :java`

This is an option for [JRuby users](https://www.jruby.org/) which will use the clipboard functionality from the Java standard library.

#### GTK+

Activate with: `Clipboard.implementation = :gtk`

This utilizes the **GTK+** library. See [Ruby-GNOME2](https://github.com/ruby-gnome2/ruby-gnome2#ruby-gnome2) for more info.

Requires the `gtk3` or `gtk2` gem to be installed.

#### OSC52

Activate with: Clipboard.implementation = :osc52

OSC52 is an ANSI escape sequence that some terminals support to access the system clipboard. One advantage of using this clipboard proider is that it is possible to copy from remote ssh sessions to your system clipboard.

As of the current version, only **copy** and **clear** commands are supported (no **paste**).

**Please note**: Even if your terminal includes OSC52 functionality, the feature could be (partially) disabled to prevent malicious scripts from accessing (or setting) your clipboard.

## Tips & Tricks

### Linux: Using Clipboard via SSH

To be able to use the clipboard through SSH, you need to install `xauth` on your server and connect via `ssh -X` or `ssh -Y`. Please note that some server settings restrict this feature.

### Linux: Paste From Specific X11 Selection

The clipboard on Linux is divided into multiple clipboard selections. You can choose from which clipboard you want to `paste` from by passing it as an argument. The default is *:clipboard*, other options are *:primary* and *:secondary*.

`Clipboard.copy` always copies to all three clipboards.

### Windows: Encoding Info

Windows uses [UTF-16LE](https://en.wikipedia.org/wiki/UTF-16) as its default encoding, so pasted strings will always come in UTF-16. You can then manually convert them to your desired encoding, for example, UTF-8, using the [String#encode](https://rubyapi.org/o/string#method-i-encode) method:

```ruby
Clipboard.paste.encode('UTF-8')
```

### CLI Utility: blip

The [blip gem]((https://gist.github.com/janlelis/781835)) is a handy command-line wrapper for the clipboard gem. It lets you quickly copy file content to your clipboard:

```
$ blip FILE_NAME
```

Without any arguments, it will just paste the contents of the clipboard.

## Further Development

This is a list of nice-to-have features - feel free to open a PR or let me know if you want to work on one of these:

- Native support for clipboard on X11 or Wayland
- Support more platforms
- Support clipboard meta data

## MIT

Copyright (c) 2010-2024 Jan Lelis <https://janlelis.com> released under the MIT license. Contributions by and thanks to [Michael Grosser and all the other contributors!](https://github.com/janlelis/clipboard/graphs/contributors)

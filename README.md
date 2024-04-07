# Clipboard Ruby Gem 📋︎ [![version](https://badge.fury.io/rb/clipboard.svg)](https://badge.fury.io/rb/clipboard) [![[ci]](https://github.com/janlelis/clipboard/workflows/Test/badge.svg)](https://github.com/janlelis/clipboard/actions?query=workflow%3ATest)

Lets you access the system clipboard from everywhere. Currently supported platforms:

- Linux (X11)
- Linux (Wayland)
- MacOS
- Windows
- Cygwin (POSIX environment for Windows)
- WSL (Windows Subsystem for Linux)
- Gtk+ (Cross Platform Widget Toolkit)
- Java (on JRuby)
- *Experimental:* OSC52 (ANSI escape sequence) **only copying** - see note below

Supported Rubies: **3.3**, **3.2**, **3.1**, **3.0**

Unsupported, but might still work: **2.X** (use clipboard gem version 1.x)

## Usage

* `Clipboard.copy` - Copies a string to system clipboard
* `Clipboard.paste` - Paste text contents from system clipboard as string
* `Clipboard.clear` - Empties the system clipboard

## Setup

Run `gem install clipboard` (and `gem install ffi` on Windows) or add the following lines to your `Gemfile`:

```ruby
gem "clipboard"
gem "ffi", :platforms => [:mswin, :mingw] # Necessary on Windows
```

**Important note for Linux** users: The clipboard gem requires additional programs to be available:

- On X11: **xsel** or **xclip**
- On Wayland: **wl-copy** and **wl-paste** (wl-clipboard) - depending on your system, just having **xsel** / **xclip** might also work


## Clipboard Implementations

In most environments, the appropriate clipboard implementation can be detected automatically. If none is found, the gem will fallback to a file based one, which will just write to/read from `~/.clipboard` instead of the system clipboard.

You can check the implementation used with `Clipboard.implementation` or set a specific implementation with `Clipboard.implementation = ...`

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

Activate with: `Clipboard.implementation = :osc52`

OSC52 is an ANSI escape sequence that some terminals support to access the system clipboard. One advantage of using this clipboard proider is that it is possible to copy from remote ssh sessions to your system clipboard.

As of the current version, only **copy** and **clear** commands are supported (no **paste**).

**Please note**: Even if your terminal includes OSC52 functionality, the feature could be (partially) disabled to prevent malicious scripts from accessing (or setting) your clipboard.

## Tips & Tricks

### Linux: Using Clipboard via SSH

To be able to use the clipboard through SSH (using the `xsel`/`xclip` based implementation), you need to install `xauth` on your server and connect via `ssh -X` or `ssh -Y`. Please note that some server settings restrict this feature.

### Linux: Copy To or Paste From Specific Clipboard / Selection

The clipboard on Linux is divided into multiple clipboard selections. You can choose from which clipboard you want to `paste` from by passing it as the first argument. The default is *:clipboard*, other options are *:primary* and, for some implementations, *:secondary*:

```ruby
Clipboard.paste("primary") # or
Clipboard.paste(clipboard: "primary")
```

`Clipboard.copy` will copy to all available clipboards, except if you specifiy a clipboard using the `clipboard:` keyword argument:

```ruby
Clipboard.copy("only goes to primary clipboard", clipboard: "primary")
```

### Windows: Encoding Info

Windows uses [UTF-16LE](https://en.wikipedia.org/wiki/UTF-16) as its default encoding, so pasted strings will always come in UTF-16. You can then manually convert them to your desired encoding, for example, UTF-8, using the [String#encode](https://rubyapi.org/o/string#method-i-encode) method:

```ruby
Clipboard.paste.encode('UTF-8')
```

### CLI Utility: blip

The [blip gem](https://rubygems.org/gems/blip) is a handy command-line wrapper for the clipboard gem. It lets you quickly copy a file's content to your clipboard:

```
$ blip FILE_NAME
```

Without any arguments, it will just paste the contents of the clipboard.

## MIT

Copyright (c) 2010-2024 Jan Lelis <https://janlelis.com> released under the MIT license. Contributions by and thanks to [Michael Grosser and all the other contributors!](https://github.com/janlelis/clipboard/graphs/contributors)

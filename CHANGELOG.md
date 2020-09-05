# CHANGELOG

## 1.3.5
* Fix missing String#+@ method on Ruby <2.3, patch by @AaronC81

## 1.3.4
* Don't break on Ruby 2.1, patch by @grosser

## 1.3.3

* Fix Cygwin implementation to work when File constant is loaded, fix by @ntachino

## 1.3.2
* Windows version actually mutates a string, fix by @scivola

## 1.3.1
* Prefer xsel over xclip, because it can handle more data
  * See here: https://github.com/janlelis/clipboard/pull/33/files#diff-80752ab4de37ec2dcf1dc85457e09d40R13

## 1.3.0
### Bug Fixes
* Conditionally read or don't read the output stream of external commands, fixes #32
  * Special thanks to @orange-kao for the bug report + PR

### New Features
* Add a GTK based clipboard

### Internal changes
* Use frozen string literals

## 1.2.1
* Add WSL to autoloaded constants

## 1.2.0
* Support WSL (Windows Subsystem for Linux)

## 1.1.2
* Linux: Replace calls to `which` with native check (thanks @woodruffw)

## 1.1.1
* Surpress 3rd party processes' STDERR, see #26
* Internal API changes to meet modified relaxed ruby style guidelines

## 1.1.0
* Remove support for 1.8
* Windows: Fix that the gem tries to convert encoding of pasted strings, leave this to user
* Support Cygwin's clipboard

## 1.0.6
* Improve Linux xsel support #17

## 1.0.5
* Windows 1.9 multibyte support

## 1.0.4
* Restore 1.8 Support

## 1.0.3
* Don't load current version from file (gh#15)

## 1.0.2
* Add missing require 'rbconfig'
* File backend: File only accessible by owner
* Small tweaks

## 1.0.1
* Fix permissions in packaged rubygem

## 1.0.0
* Add basic java clipboard support

## 0.9.9
* Allow Ocra packing

## 0.9.8
* Fix a Windows bug

## 0.9.6 / 0.9.7
* Support rubygems-test ("gem test clipboard" if rubygems-test is installed)

## 0.9.5
* Fallback to Clipboard::File, if no other clipboard is available
* Also check for xsel if using linux implementation
* Fix for jruby copying
* You can directly use a specific implementation, e.g.: require
  'clipboard/file' # gives you Clipboard::File

## < 0.9.4
See https://github.com/janlelis/clipboard/commits/0.9.4

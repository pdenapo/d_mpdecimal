
# d-mpdecimal

[mpdecimal](https://www.bytereef.org/mpdecimal/) is a package for correctly-rounded arbitrary precision decimal 
floating point arithmetic writter by Stefan Krah.

This project offers bindings and a wrapper for using limpdec from 
D language.

(C) 2021 by Pablo De Nápoli (pdenapo AT gmail.com)

* d_mpdecimal.deimos is a translation of the original header from C to D.
  (This allows you to call the libmpec functions from D).

* d_mpdecimal.decimal is a high-level wrapper over libmpec using the
  features of the D language (like structs and operator overloading).

This work is distributed under the MIT license (see the LICENSE file).

Some sample test programs are also provided.

This package has been only tested in GNU/Linux, and it is designed for 64 bit systems
(Help with testing and porting is welcome).

In Debian/Ubuntu you can install libmpec by installing the package
[libmpdec-dev](https://packages.debian.org/bullseye/libmpdec-dev).



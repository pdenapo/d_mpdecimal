Error: No word lists can be found for the language "es_AR".
# d-mpdecimal

mpdecimal is a package for correctly-rounded arbitrary precision decimal 
floating point arithmetic writter by Stefan Krah.

This project offers bindings and a wrapper for using limpdec from 
D language.

(C) 2021 by Pablo De Nápoli (pdenapo AT gmail.com)

* mpdec.mpdec is a translation of the original header from C to D.
  (This allows you to call the libmpec functions from D).

* mpdec.decimal is a high-level wrapper over libmpec using the
  features of the D language (like structs and operator overloading).

This work is distributed under the MIT license (see the LICENSE file).

Some sample test programs are also provided.
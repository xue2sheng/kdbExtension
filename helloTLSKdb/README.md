# Mixing TLS with Kdb 

If the previous TLS proof of concept got our thumbs up, it's time of mixing TLS code with KDB one. Take into account that **k.h** introduces a lot of macros that don't get along with Boost libraries; the order of the headers is important at this point (we're not using C++ Module features on a regular basis yet).

Try to minimize future integration with current code by following similar **signatures** for non-TLS connection functions. I mean if the non-TLS current funtion is called [khpun](https://code.kx.com/q/interfaces/capiref/#khpun-connect), our extension might be called **__khpun** or something similar.

That integration should keep both connection types: vanilla KDB non-TLS and extended TLS connection funtion working along. That's the only way for you to check you're covering all the bases and measure what penalty are you paying. Even if our **extension** is flawless and with reduced performance impact, the fact of using **TLS** will probably require to beef up our current production hardware. 

# Asio refreshment example

It's highly likely your current C++ production code uses that [Asio](https://think-async.com/Asio) library, directly from Boost or stand alone. New Boost versions come along with complementary [Boost Beast](http://github.com/boostorg/beasts) that requires more modern compilers.

Just getting a couple of sockets opened from a couple of threads in the same process should do the trick. No TLS involved at this stage but we'd better one side of those connections to stick to more classic approach (i.e. bare pre C++11 boost threads) meanwhile the other side of those connections to use more current approaches (i.e. coroutines or post C++11 standard threads).

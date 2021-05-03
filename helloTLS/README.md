# TLS example 

Very basic TLS example, trying to double check that it's possible to open different TLS connection from different threads in the very same process. That seems to be a limitation at current *kdb+* 4.0 version and there should have a good reason for that.

It's important to detect if this scenario is a deal breaker or if there is some workaround to mitigate its impact. Besides, fooling aournd with TLS certificates force us to review the usage of [openssl](https://www.openssl.org/), including all the debugging involved.

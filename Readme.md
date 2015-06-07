Ikea Stock Check
================
A small PHP script for automatically checking stock on products in Ikea stores.
I spent a few hours writing this script to automate checking stock at my local
store.  The product came back in stock before development finished so this
project was shelved.

Usage
-----
Run `bootstrap.sql` on your database host, then edit the `mysqli` instantiation
with the appropriate values.  Add `check.php` to your crontab:
```
@hourly php /path/to/check.php
```

Finally, add a row to the `requests` and `products` tables for the item(s) you
want to track.  A sample row for each is included in `bootstrap.sql`.

Copyright and License
---------------------
This code is provided for free and released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or distribute this
software, either in source code form or as a compiled binary, for any purpose,
commercial or non-commercial, and by any means.

In jurisdictions that recognize copyright laws, the author or authors of this
software dedicate any and all copyright interest in the software to the public
domain. We make this dedication for the benefit of the public at large and to
the detriment of our heirs and successors. We intend this dedication to be an
overt act of relinquishment in perpetuity of all present and future rights to
this software under copyright law.
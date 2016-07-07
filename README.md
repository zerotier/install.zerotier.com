ZeroTier `curl|bash` Installation Script
======

This repository contains the `curl|bash` install script served from [https://install.zerotier.com/](https://install.zerotier.com).

To offer a more secure installation option we use an inline GPG signature hack that allows the script to be signed but that makes signature verification optional. It's a perfectly valid script whether or not it gets run through GPG. The trick is to use a dummy multi-line variable to encapsulate the beginning of the GPG "clearsign" signature section, then to have an `exit 0` statement at the end before the actual signature. The last bit of magic is the end-of-multi-line-quote `ENDOFSIGSTART=` code that we use. Note the equals at the end. This means that the presence of that line as the first line in the script that `gpg --output` spits out doesn't break bash since it's just a null variable assign no-op.

This hack lets us offer the user two options:

**Quick and dirty:**

    curl -s https://install.zerotier.com/ | bash

**Foil hat mode:**

    curl -s https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg | gpg --import
    curl -s https://install.zerotier.com/ | gpg --output - >/tmp/zt-install.sh && bash /tmp/zt-install.sh

You will not be able to build *our* script using just this repo since you'd need the *contact@zerotier.com* GPG secret key, but you are free to adapt it and host it elsewhere or look at what's here and steal our inline signature technique.

The `install.sh.in` file contains the script source minus the signature, while `build-install.sh` is a short shell script that signs it and concatenates it all together into the actuall install payload.

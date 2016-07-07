ZeroTier `curl|bash` Installation Script
======

This repository contains the `curl|bash` install script served from [https://install.zerotier.com/](https://install.zerotier.com).

The `install.sh.in` file contains the script source minus the signature, while `build-install.sh` is a short shell script that signs it and concatenates it all together into the actuall install payload. You will need to edit the latter if you want to use it yourself since you will not have our *contact@zerotier.com* GPG secret key.

The GPG signed script built from `install.sh.in` uses a clever little hack to yield a script that is valid regardless of whether it's been passed through `gpg --output` to check its signature or not, offering two options to users:

**Living dangerously (https check only):**

    curl -s https://install.zerotier.com/ | bash

**Foil hat mode (2X redundant https + GPG):**

    curl -s https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg | gpg --import
    curl -s https://install.zerotier.com/ | gpg --output - >/tmp/zt-install.sh && bash /tmp/zt-install.sh

This is accomplished by signing the script with GPG's `--clearsign` mode and then using a multi-line bash escape to escape the begin signature lines. Since the script ends with `exit 0` the actual signature at the end is also ignored. A final piece of this trick is the use of `ENDOFSIGSTART=` as the magic multi-line escape sequence. Since it ends with an equals it converts into a no-op assignment after `gpg --output` strips away the script's first few lines, allowing GPG's output to be piped straight into *bash* if the signature check is successful.

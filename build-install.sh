#!/bin/bash

gpg -u contact@zerotier.com --digest-algo SHA256 --clearsign install.sh.in

echo '#!/bin/bash' >install.sh
echo '<<ENDOFSIGSTART=' >>install.sh
cat install.sh.in.asc >>install.sh

rm -f install.sh.in.asc
mv -f install.sh htdocs/install.sh

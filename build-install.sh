#!/bin/bash

gpg --digest-algo SHA256 --clearsign install.sh.in

echo '#!/bin/bash' >install.sh
echo '<<ENDOFSIGSTART=' >>install.sh
cat install.sh.in.asc >>install.sh

rm -f install.sh.in.asc

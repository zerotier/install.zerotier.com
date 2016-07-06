#!/bin/bash

gpg --clearsign install.sh.in

echo '#!/bin/bash' >install.sh
echo '<<ENDOFSIGSTART' >>install.sh
cat install.sh.in.asc >>install.sh

rm -f install.sh.in.asc

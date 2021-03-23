#!/bin/bash
chown 99:100 -R /megamek
chmod 776 -R /megamek
su megamek -c 'java -Xms768m -Xmx768m -jar MegaMek.jar -dedicated -port 2346'

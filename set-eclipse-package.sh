#!/bin/bash
SOURCE=$(dirname -- ${BASH_SOURCE[0]})

ECLIPSE_PACKAGE=${ECLIPSE_PACKAGE:='eclipse-java'}

SNAPCRAFT_YAML=$SOURCE/snap/snapcraft.yaml

yq ea "
select(fi==0).latest as \$version |
select(fi==0).[\$version].$ECLIPSE_PACKAGE as \$package |
select(fi==1).name=\"$ECLIPSE_PACKAGE\" |
select(fi==1).version=\$version |
select(fi==1).parts.eclipse.source = \$package.source |
select(fi==1).parts.eclipse.source-checksum = \$package.checksum |
select(fi==1).apps.$ECLIPSE_PACKAGE = select(fi==1).apps.eclipse |
del(.apps.eclipse) |
select(fi==1)
" $SOURCE/eclipse-packages.yaml $SOURCE/snapcraft.yaml.template | tee $SNAPCRAFT_YAML

echo written $SNAPCRAFT_YAML for $ECLIPSE_PACKAGE.

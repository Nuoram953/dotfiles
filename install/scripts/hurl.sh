#!/bin/bas

VERSION=4.2.0

curl --location --remote-name https://github.com/Orange-OpenSource/hurl/releases/download/$VERSION/hurl_${VERSION}_amd64.deb

sudo apt update && sudo apt install ./hurl_${VERSION}_amd64.deb

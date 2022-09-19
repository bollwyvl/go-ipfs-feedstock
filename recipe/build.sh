#!/usr/bin/env bash
set -eux

export GOPATH="$( pwd )"
export CGO_ENABLED=1
export CGO_CFLAGS="${CFLAGS}"
export CGO_CXXFLAGS="${CPPFLAGS}"
export CGO_LDFLAGS="${LDFLAGS}"
export GOFLAGS="-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=vendor -modcacherw"
export GOTAGS="openssl"

uname

if [ $(uname) == Darwin ]; then
    export GOFLAGS="--with-libraries=${PREFIX}/lib ${GOFLAGS}"
    export CGO_CFLAGS="-I${PREFIX}/include/ ${CGO_CFLAGS}"
    export CGO_LDFLAGS="-L${PREFIX}/lib/ ${CGO_LDFLAGS}"
fi

module='github.com/ipfs/kubo'

make -C "src/${module}" install nofuse

pushd "src/${module}"
    mkdir -p ${PREFIX}/bin
    cp cmd/ipfs/ipfs ${PREFIX}/bin
    bash $RECIPE_DIR/build_library_licenses.sh
popd

#!/bin/bash
# this is a sorry excuse for a test, but hey, it kinda works

#tmpdir=$(mktemp -d)
tmpdir=temp;mkdir -p $tmpdir

# alias podman=podman

./create-test-files.sh $tmpdir
# Usage: ./entrypoint.sh folder/file-patttern CRLF/LF/MIXED INCLUDE_PATTERN EXCLUDE_PATTERN
set -f
set -o noglob

echo 'Building test image...'
podman build -t crlf-test .

echo '\nCheck: folder, CRLF only, include all, no exclude'
podman run -t --rm -v $(realpath $tmpdir):$(realpath $tmpdir) crlf-test $(realpath $tmpdir) crlf '*'

echo '\nCheck: folder, CRLF only, include some, no exclude'
podman run -t --rm -v $(realpath $tmpdir):$(realpath $tmpdir) crlf-test $(realpath $tmpdir) CRLF "exclude-crlf*"

echo '\nCheck: folder, CRLF only, include some, exclude sub dir'
podman run -t --rm -v $(realpath $tmpdir):$(realpath $tmpdir) crlf-test $(realpath $tmpdir) CRLF "exclude-crlf*" "subdir/*"

echo '\nCheck: folder, LF only, include all, no exclude'
podman run -t --rm -v $(realpath $tmpdir):$(realpath $tmpdir) crlf-test $(realpath $tmpdir) lf "*"

echo '\nCheck: folder, LF only, include some, no exclude'
podman run -t --rm -v $(realpath $tmpdir):$(realpath $tmpdir) crlf-test $(realpath $tmpdir) lf "exclude-lf*"

echo '\nCheck: folder, mixed, include all, no exclude'
podman run -t --rm -v $(realpath $tmpdir):$(realpath $tmpdir) crlf-test $(realpath $tmpdir) mixed "*"

echo '\nCheck: folder, mixed, include some, no exclude'
podman run -t --rm -v $(realpath $tmpdir):$(realpath $tmpdir) crlf-test $(realpath $tmpdir) mixed "crlf*"

RESULT="$?"

rm -rv "$tmpdir"

[ -z $KEEP_TEST_IMAGE ] && podman rmi crlf-test
exit $RESULT

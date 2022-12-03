#!/bin/bash
# this is a sorry excuse for a test, but hey, it kinda works

#tmpdir=$(mktemp -d)
tmpdir=temp;mkdir -p $tmpdir

# alias podman=podman

./create-test-files.sh $tmpdir
# Mandatory arguments
# folder="$1"
# line_ending_type="$(echo "$2" | tr '[:upper:]' '[:lower:]')"

# # Optional arguemnts, empty by default
# include_regex="$3"
# exclude_regex="$4"
# exclude_first="$(echo "$5" | tr '[:upper:]' '[:lower:]')"
# max_folder_depth=$6
# Usage: ./entrypoint.sh folder/file-patttern CRLF/LF/MIXED include_regex exclude_regex exclude_first max_folder_depth
set -f
set -o noglob

echo 'Building test image...'
podman build -t crlf-test .

echo -e '\nCheck: folder, CRLF only, include all, no exclude'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . crlf

echo -e '\nCheck: folder, CRLF only, include onlcude exclude*, no exclude'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . CRLF "exclude-crlf"

echo -e '\nCheck: folder, CRLF only, include some, exclude subdir'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . CRLF "crlf.*" "^\./subdir"

echo -e '\nCheck: folder, LF only, include all, no exclude'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . lf

echo -e '\nCheck: folder, LF only, include some, no exclude'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . lf "exclude-lf"

echo -e '\nCheck: folder, LF only, include only ./subdir/ exlude all "exclude" files'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . lf "^\./subdir/" "exclude"

echo -e '\nCheck: folder, mixed, include all, no exclude'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . mixed

echo -e '\nCheck: folder, mixed, include some, no exclude'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . mixed "crlf.*"

echo -e '\nCheck: folder, mixed, include some, no exclude'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . mixed "crlf.*"

RESULT="$?"

rm -r "$tmpdir"

[ -z "$KEEP_TEST_IMAGE" ] && podman rmi crlf-test
exit $RESULT

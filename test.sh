#!/bin/sh
# this is a sorry excuse for a test, but hey, it kinda works

#tmpdir=$(mktemp -d)
tmpdir=temp;mkdir -p $tmpdir

printf "Line1\r\nLine2" >"$tmpdir/crlf-only"
printf "Line1\r\nLine2\nLine3" >"$tmpdir/crlf-with-lf-mwixed"
printf "Line1\nLine2" >"$tmpdir/lf-only"
printf "Line1\r\nLine2" >"$tmpdir/exclude-crlf"
printf "Line1\nLine2" >"$tmpdir/exclude-lf"
printf "Line1\r\nLine2\nLine3" >"$tmpdir/exclude-mixed"
# exit
# Usage: ./entrypoint.sh folder/file-patttern CRLF/LF/MIXED INCLUDE_PATTERN EXCLUDE_PATTERN

echo Check: folder, CRLF only, include all, no exclude
./entrypoint.sh $tmpdir CRLF "\*"

echo Check: folder, CRLF only, include some, no exclude
./entrypoint.sh $tmpdir CRLF "exclude-crlf*"

echo Check: folder, LF only, include all, no exclude
./entrypoint.sh $tmpdir lf "\*"

echo Check: folder, LF only, include some, no exclude
./entrypoint.sh $tmpdir lf "exclude-lf*"

echo Check: folder, mixed, include all, no exclude
./entrypoint.sh $tmpdir mixed "\*"

echo Check: folder, mixed, include some, no exclude
./entrypoint.sh $tmpdir mixed "crlf*"

RESULT="$?"

rm -rv "$tmpdir"

# is there a better way to do this?
[ $RESULT -eq 1 ]
exit $?

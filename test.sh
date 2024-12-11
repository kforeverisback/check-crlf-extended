#!/bin/bash
# this is a sorry excuse for a test, but hey, it kinda works

# TODO: use mktemp for final version
#tmpdir=$(mktemp -d)
tmpdir=temp;mkdir -p $tmpdir

alias podman=podman

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

GITHUB_OUTPUT=$(mktemp)
export GITHUB_OUTPUT="$GITHUB_OUTPUT"
# echo -e '\nCheck: folder, Ending: CRLF only'
# echo -e '=========================='
# echo -e 'Include all, no exclude'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . crlf

# echo -e '\nInclude regex: "." exlude regex: "^exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . CRlf . "exclude\.*"

# echo -e '\nInclude regex: "./subdir with space/.*" exlude regex: "^exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . CRlf "/subdir with space/.*" "exclude\.*"

# echo -e '\nInclude regex: "crlf.*", exclude regex: "subdir/crlf.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . CRLF "crlf.*" "subdir/crlf.*"

# echo -e '\nInclude regex: ""./subdir/crlf.*"" exlude regex: "exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . CRlf "\/subdir/crlf.*" "exclude.*"

# echo -e '\nInclude regex: "^./subdir/" exlude regex: "^exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . CRlf "^\./subdir/" "exclude\.*"

echo -e '\nCheck: folder, Ending: LF only'
echo -e '=========================='
echo -e 'Include all, no exclude'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" -crlf-test -t . -l lf

echo -e '\nInclude regex: ".*" exclude regex: "^exclude.*"'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test -t . -l LF -i ".*" -e "exclude.*"

echo -e '\nInclude regex: ".*" exclude regex: "^exclude.*", Max dir depth: 1 (no subdir)'
podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test -t . -l LF -i ".*" -e "exclude.*" -d 1

# echo -e '\nInclude regex: "./subdir with space/.*" exlude regex: "^exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . Lf "/subdir with space/.*" "exclude\.*"

# echo -e '\nInclude regex: "lf.*", exclude regex: "subdir/lf.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . lF "lf.*" "subdir/crlf.*"

# echo -e '\nInclude regex: ""./subdir/lf.*"" exlude regex: "exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . LF "\/subdir/lf.*" "exclude.*"

# echo -e '\nInclude regex: "^./subdir/" exlude regex: "^exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . LF "^\./subdir/" "exclude\.*"

# echo -e '\nCheck: folder, Ending: CRLF-LF-mixed only'
# echo -e '=========================='
# echo -e 'Include all, no exclude'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . mixed

# echo -e '\nInclude regex: "." exlude regex: "^exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . MixeD . "exclude\.*"

# echo -e '\nInclude regex: "./subdir with space/.*" exlude regex: "^exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . mixED "/subdir with space/.*" "exclude\.*"

# echo -e '\nInclude regex: "crlf-with-lf-mixed.*", exclude regex: "subdir/crlf-with-lf-mixed.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . CRLF "crlf-with-lf-mixed.*" "subdir/crlf-with-lf-mixed.*"

# echo -e '\nInclude regex: ""./subdir/crlf-with-lf-mixed.*"" exlude regex: "exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . CRlf "\/subdir/crlf-with-lf-mixed.*" "exclude.*"

# echo -e '\nInclude regex: "^./subdir/" exlude regex: "^exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . CRlf "^\./subdir/" "exclude\.*"
# rm -r "$tmpdir"
# exit 0
# echo -e '\nCheck: folder, Ending: LF only'
# echo -e '================================'
# echo -e '\nInclude all, no exclude'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . lf

# echo -e '\nInclude regex: "exclude-lf", no exclude'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . lf "exclude-lf"


# echo -e '\nInclude regex: "lf.*", exclude regex: "^\./subdir"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . LF "lf.*" "^\./subdir"

# echo -e '\nInclude regex: "^./subdir/" exlude regex: "^exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . lf "^\./subdir/" "exclude.*"

# echo -e '\nCheck: folder, Ending: mixed'
# echo -e '================================'
# echo -e '\nInclude all, no exclude'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . mixed

# echo -e '\nInclude regex: "exclude-crlf-with-lf-mixed", no exclude'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . MixeD "exclude-crlf-with-lf-mixed"

# echo -e '\nInclude regexL "mixed", exclude regex: "^\./subdir"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . MIXED "mixed" "^\./subdir"

# echo -e '\nInclude regex: "^./subdir/" exlude regex: "^exclude.*"'
# podman run -t --rm --workdir /repo -v "$(realpath $tmpdir):/repo" crlf-test . mixed "^\./subdir/" "exclude.*"

RESULT="$?"

# rm -r "$tmpdir"

[ -z "$KEEP_TEST_IMAGE" ] && podman rmi crlf-test
exit $RESULT

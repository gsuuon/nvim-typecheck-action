#!/bin/bash
set -e
HERE=$(dirname "$(realpath "$0")")

EXTRA_ARGS=
if [ -n "$INPUT_NEODEV_REV" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --neodev-rev $INPUT_NEODEV_REV"
fi
if [ -n "$INPUT_CONFIGPATH" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --configpath $INPUT_CONFIGPATH"
fi
if [ -n "$INPUT_LIBRARIES" ]; then
  for lib in $INPUT_LIBRARIES; do
    EXTRA_ARGS="$EXTRA_ARGS --lib $lib"
  done
fi
if [ "$INPUT_ANNOTATE" == "true" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --annotate"
fi

set +e
nvim --headless -u /dev/null --noplugin -l "$HERE/typecheck.lua" "$@" $EXTRA_ARGS

NVIM_EXIT=$?

if test -f ./summary.md; then
  cat ./summary.md > $GITHUB_STEP_SUMMARY
else
  echo 'No summary found'
fi

exit "$NVIM_EXIT"

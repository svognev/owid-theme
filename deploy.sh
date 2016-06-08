#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RSYNC="rsync -havz --no-perms --progress --delete --delete-excluded --exclude-from=$DIR/.rsync-ignore"

if [ "$1" == "test" ]; then
  NAME="owid-theme"
  ROOT="/var/www"
  HOST="root@terra"
elif [ "$1" == "live" ]; then
  NAME="owid-theme"
  ROOT="/home/explain3"
  HOST="explain3@whm.ourworldindata.org"
else
  echo "Please select either live or test."
  exit 1
fi

OLD_REPO="$ROOT/tmp/$NAME-old"
SYNC_TARGET="$ROOT/tmp/$NAME"
TMP_NEW="$ROOT/tmp/$NAME-new"
LIVE_TARGET="$ROOT/$NAME"

ssh -t $HOST "rm -r $OLD_REPO"
$RSYNC $DIR/ $HOST:$SYNC_TARGET
ssh -t $HOST 'bash -e -s' <<EOF
  cp -r $SYNC_TARGET $TMP_NEW
  mv $LIVE_TARGET $OLD_REPO
  mv $TMP_NEW $LIVE_TARGET
EOF


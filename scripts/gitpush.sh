#!/bin/bash
cd ~/.dotfiles-pth || exit

git add .
msg="$*"
if [ -z "$msg" ]; then
  msg="🔄 Update dotfiles"
fi

git commit -m "$msg"
git push

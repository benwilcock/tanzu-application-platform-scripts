#!/bin/bash

tanzu apps workload create python-sample \
  --git-repo https://github.com/benwilcock/python-pipenv \
  --git-branch main \
  --type web \
  --label app.kubernetes.io/part-of=python-sample \
  --namespace default \
  --tail \
  --yes 
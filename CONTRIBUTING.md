# Contributing

> [!IMPORTANT]
> This is unfinished.

This workflow generates a new token for the Cellarman GitHub App.
This token is used throughout the workflow. This is necessary because of the
ruleset in place on this repository. This ruleset does a couple of things:

1. It blocks PR's from being merged without `brew test-bot / test-bot`
   passing.
2. It blocks all direct modifications to `main` by us mere mortals. Instead,
   `main` can only be modified by Cellarman.
   This means the only way modifications can be made in this repo are by opening
   pull requests, waiting for test-bot to pass, then applying the `pr-pull` label
   to each PR which triggers Cellarman to act.

PR's don't actually get merged. Instead, their commits are cherry-picked and
directy applied to `main`. For this reason you need to be very careful about
keeping git history clean if you merge main back into PR branches.

# Contributing

<!-- This workflow generates a new token for the Cellarman GitHub App. -->
<!-- This token is used throughout the workflow. This is necessary because of the -->
<!-- ruleset in place on this repository. This ruleset does a couple of things: -->
<!---->
<!-- 1. It blocks PR's from being merged without `brew test-bot / test-bot` -->
<!--    passing. -->
<!-- 2. It blocks all direct modifications to `main` by us mere mortals. Instead, -->
<!--    `main` can only be modified by Cellarman. -->
<!--    This means the only way modifications can be made in this repo are by opening -->
<!--    pull requests, waiting for test-bot to pass, then applying the `pr-pull` label -->
<!--    to each PR which triggers Cellarman to act. -->
<!---->
<!-- PR's don't actually get merged. Instead, their commits are cherry-picked and -->
<!-- directy applied to `main`. For this reason you need to be very careful about -->
<!-- keeping git history clean if you merge main back into PR branches. -->

---

> [!IMPORTANT]
> This is only meant for me, [@peter-bread](https://github.com/peter-bread).
> This tap is only for my software.
>
> If you are not me feel free to read to see how it all works.
>
> If I am doing something wrong, please open an issue, but do not open issues
> or pull requests regarding the addition of new software. In that case, create
> your own tap or contribute to
> [homebrew-core](https://github.com/Homebrew/homebrew-core).

---

This is a guide for how this tap is operated.

## Summary

1. All changes must be made via pull requests.
1. Pull requests can only be merged[\*](#publish) by adding the `pr-pull` label after
   `test-bot` has passed.
1. Only the Cellarman GitHub App has permission to write to `main`.

## Adding a new formula

Tap the repository if you haven't already:

```bash
brew tap peter-bread/tap
```

Navigate to the tap:

```bash
cd "$(brew --repository peter-bread/tap)"
```

Create a new formula with `brew create`. Check `brew create --help` to see
more, for example how to generate a basic template for different project types.

```bash
brew create --tap=peter-bread/tap https://github.com/peter-bread/<formula>/archive/v<X.Y.Z>.tar.gz
```

Edit the formula with `brew edit`.

```bash
brew edit peter-bread/tap/<formula>
```

Create a new branch, add the formula, then commit and push to the tap.

```bash
git checkout -b <formula>
git add Formula/<formula>.rb
git commit -m "<formula> X.Y.Z (new formula)"
git push -u origin <formula>
```

Wait for `test-bot` to succeed. Then add the `pr-pull` label. For more
information, see [Automation](#automation).

## Manually updating a formula

This is for making changes to a formula that are _NOT_ version bumps.

This is essentially the same workflow as [adding a new
formula](#adding-a-new-formula) but without the `brew create` step.

When creating a branch, the name should be the formula followed by a very, very
brief description of the changes, e.g. `<formula>-fix-build` or
`<formula>-update-test`.

The commit message should be similar, e.g. `<formula>: fix build`.

```bash
git checkout -b <formula>-<desc>
git add Formula/<formula>.rb
git commit -m "<formula>: <desc>"
git push -u origin <formula>-<desc>
```

## Bumping a formula

In the repository containing the source code of a formula???, ensure you have a
workflow that creates tags and GitHub Releases.

In your repository settings, add the `App ID` and private key for
[Cellarman](https://github.com/settings/apps/peter-bread-cellarman) to your
variables and secrets respectively.

Create a new job that depends on the success of the release job. This job
will create a token using the Cellarman App which has the minimum required
permissions to send a repository dispatch to this homebrew tap. It should
send a `bump` event with a payload containing the key `formula`, whose value
should be the name of the formula, which will normally be the name of the
repository.

Below is an example job:

```yaml
---
bump-homebrew-formula:
  runs:on: ubuntu-latest
  needs: <release-job>
  if: ${{ needs.<release-job>.result == 'success' }}
  env:
    OWNER: ${{ github.repository_owner }}
    REPO: ${{ github.event.repository.name }}
    TAP: ${{ vars.HOMEBREW_TAP }} # or `TAP: homebrew-tap`

  steps:
    - uses: actions/create-github-app-token@v2
      id: app-token
      with:
        app-id: ${{ vars.CELLARMAN_APP_ID }}
        private-key: ${{ secrets.CELLARMAN_APP_PRIVATE_KEY }}
        owner: ${{ env.OWNER }}
        repositories: ${{ env.TAP }}

    - uses: peter-evans/repository-dispatch@v3
      with:
        token: ${{ steps.app-token.outputs.token }}
        repository: ${{ env.OWNER }}/${{ env.TAP }}
        event-type: bump
        client-payload: |-
          {
            "formula": "${{ env.REPO }}"
          }
```

## Automation

This repository is meant to be as automated as possible and as hard to make a
mistake as possible. This is achieved using a number of GitHub Actions workflows
as well as [rulesets](#rulesets) to protect the `main` branch.

This section will explain each of the workflows.

### Bump

[Workflow](./.github/workflows/bump.yml).

### Tests

[Workflow](./.github/workflows/tests.yml).

### Publish

[Workflow](./.github/workflows/publish.yml).

### PR Notice

[Workflow](./.github/workflows/pr-notice.yml).

## Rulesets

[Rulesets](https://github.com/peter-bread/homebrew-tap/rules?ref=refs%2Fheads%2Fmain).

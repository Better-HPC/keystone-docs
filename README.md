# Keystone Documentation

This repository acts as a GitOps staging ground for publishing the Keystone documentation.
Project level documentation is stored in this repository and combined with component level documentation
(e.g., Keystone-API, Keystone-Web) via Git submodules.

## Working Locally

This repository leverages submodules.
To clone the repository with submodules included:

```shell
git clone [URL] --recurse-submodules
```

Submodules can also be pulled and updated manually:

```shell
git submodule update --init
```

After ensuring the submodules are up-to-date, make sure to (re)install the project dependencies.

```shell
pip install -r requirements.txt
```

Documentation is compiled and served locally using the `mkdocs` utility.

```shell
mkdocs serve
```

## Working in CI

New documentation is automatically built and published whenever# Keystone Documentation

This repository acts as a GitOps staging ground for publishing the Keystone documentation.
Project level documentation is stored in this repository and combined with component level documentation
(e.g., Keystone-API, Keystone-Web) via Git submodules.

## Working Locally

This repository leverages submodules.
To clone the repository with submodules included:

```shell
git clone [URL] --recurse-submodules
```

Submodules can also be pulled and updated manually:

```shell
git submodule update --init
```

After ensuring the submodules are up-to-date, make sure to (re)install the project dependencies.

```shell
pip install -r requirements.txt
```

Documentation is compiled and served locally using the `mkdocs` utility.

```shell
mkdocs serve
```

## Working in CI

New documentation is automatically published any time a commit is made to the `main` branch of this repository.
A custom GitHub action is also used to rebuild the documentation when changes are made to the upstream submodules.

To initiate builds from an upstream repository, the `Keystone-GitOps` application must be installed in that repository.
Once installed, builds can be triggered via CI using a workflow job similar to the example below.
Authentication and permissions are managed by the GitHub application, which is identified using its application ID
(`keystone-gitops-id`) and private key (`keystone-gitops-pk`). The action also requires the name of the submodule to
update (`repo-name`) and the desired submodule tag (`tag`).

```yml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Update docs
        uses: better-hpc/keystone-docs/.github/actions/update-action/@main
        with:
          keystone-gitops-id: ${{ secrets.KEYSTONE_GITOPS_ID }}
          keystone-gitops-pk: ${{ secrets.KEYSTONE_GITOPS_PK }}
          repo-name: keystone-api
          tag: tags/v0.3.8
```

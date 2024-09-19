# Keystone Documentation

This repository acts as a GitOps staging ground for publishing the Keystone documentation.
Project level documentation is stored in this repository and combined with component level documentation
(e.g., Keystone-API, Keystone-Web) via Git submodules.

## Resources

- [Keystone-API](https://github.com/better-hpc/keystone-api): Backend REST API for managing HPC allocations and resources.
- [Keystone-Web](https://github.com/better-hpc/keystone-web): Website frontend for HPC administration and self-service.
- [Keystone-Python-Client](https://github.com/better-hpc/keystone-python-client): A light-weight Python client for Keystone API.
- [Keystone-Docs](https://github.com/better-hpc/keystone-docs): Documentation for the Keystone project and its components.

## Getting Started

### Working Locally

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

Documentation is compiled and served locally using the `mkdcs` utility.

```shell
mkdocs serve
```

### Working in CI

New documentation is automatically built and published every time the `main` branch is updated.
CI permissions are granted via the `Keystone-GitOps` GitHub application which must be installed on all upstream repositories.
See the organization level settings to install and configure the GitHub application on new repositories.

A composite GitHub action is provided to streamline GitOps activities against this repository.
The following example job updates the `keystone-api` submodule to tag `tags/v0.3.8` and publishes new documentation.
Authentication/permissions are handled by the GitHub application identified by its application ID (`keystone-gitops-id`) and primary key (`keystone-gitops-pk`).

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

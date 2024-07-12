# Keystone Documentation

This repository acts as a GitOps staging ground for publishing the Keystone documentation.
Project level documentation is stored in this repository and combined with component level documentation
(e.g., Keystone-API, Keystone-Web) via Git submodules.

## Resources

- [Keystone-API](https://github.com/pitt-crc/keystone-api): Backend REST API for managing HPC allocations and resources.
- [Keystone-Web](https://github.com/pitt-crc/keystone-web): Website frontend for HPC administration and self-service.
- [Keystone-Python-Client](https://github.com/pitt-crc/keystone-python-client): A lightweight Python client for Keystone API.
- [Keystone-Docs](https://github.com/pitt-crc/keystone-docs): Documentation for the Keystone project and its components.

## Usage

New documentation is automatically built and published every time the `main` branch is updated.
A composite GitHub action is provided to streamline GitOps activities against this repository.
The following example job will update the `keyston-api` submodule to tag `tags/v0.3.8` and publish new documentation.
Authentication/permissions are handled via a GitHub application identified by the application ID (`keystone-gitops-id`) and primary key (`keystone-gitops-pk`).

```yml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Update docs
        uses: pitt-crc/keystone-docs/.github/actions/update-action/@main
        with:
          keystone-gitops-id: ${{ secrets.KEYSTONE_GITOPS_ID }}
          keystone-gitops-pk: ${{ secrets.KEYSTONE_GITOPS_PK }}
          repo-name: keystone-api
          tag: tags/v0.3.8
```

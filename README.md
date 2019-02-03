# docker-terraformide

IDE docker image with Terraform and Graphviz installed.
Based on alpine docker image.

## Usage
1. Install [IDE](https://github.com/ai-traders/ide)
2. Provide an Dojofile:
```
DOJO_DOCKER_IMAGE="docker-registry.ai-traders.com/terraformide:0.5.1"
```
3. Run, example commands:
```bash
ide terraform --version
ide "terraform init && terraform plan"
```

By default, current directory in docker container is `/dojo/work`.

### Configuration
Those files are used inside gitide docker image:

1. `~/.ssh/config` -- will be generated on docker container start
2. `~/.ssh/id_rsa` -- it must exist locally, because it is a secret
 (but the whole `~/.ssh` will be copied)
2. `~/.gitconfig` -- if exists locally, will be copied
3. `~/.profile` -- will be generated on docker container start, in
   order to ensure current directory is `/dojo/work`.
4. Environment variables must be locally set:
 `[ 'OS_AUTH_URL', 'OS_TENANT_NAME', 'OS_USERNAME',
   'OS_PASSWORD']`. Dojo will pass them to the docker image.

To enable debug output:
```
OS_DEBUG=1 TF_LOG=debug
```

## Development

### Why not just use official terraform image?
So that packeride and terraformide are similar and thus easier to maintain.

### Dependencies
* Bash
* Docker daemon
* Dojo

### Lifecycle
1. In a feature branch:
 * you make changes
 * and run tests:
     * `./tasks build`
     * `./tasks itest`
1. You decide that your changes are ready and you:
 * merge into master branch
 * run locally:
   * `./tasks set_version` to set version in CHANGELOG, bump patch version
   * e.g. `./tasks set_version 1.2.3` to set version in CHANGELOG to 1.2.3
 * push to master onto private git server
1. CI server (GoCD) tests and releases.

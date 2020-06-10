# docker-terraform-gcp-dojo

[Dojo](https://github.com/kudulab/dojo) docker image with [Terraform](https://terraform.io), Go, gcloud and supporting tools installed.
Based on golang Debian docker image.

## Usage
1. Setup docker.
2. Install [Dojo](https://github.com/kudulab/dojo) binary.
2. Build this image:
```
docker build . -t terraform-gcp-dojo
```
3. Provide a Dojofile:
```
DOJO_DOCKER_IMAGE="terraform-gcp-dojo:latest"
```
4. Create and enter the container by running `dojo` at the root of project.
5. Work with terraform as usual:
```bash
terraform --version
terraform init
terraform plan
```

By default, current directory in docker container is `/dojo/work`.

## Specification

 * base image is Debian - compiling Golang under Alpine is a PITA
 * terraform binary on the PATH
 * terraform plugins: gcp, null, external, local, template, random.
 * `jq` to parse JSON from bash scripts
 * `dot` to generate infrastructure graphs from terraform
 * a minimal ssh and git setup - to clone terraform modules
 * gcloud - if ~/.config/gcloud is found it is copied to /home/dojo/.config/gcloud

### Configuration
Those files are used inside the docker image:

1. `~/.ssh/` -- is copied from host to dojo's home `~/.ssh`
1. `~/.ssh/config` -- will be generated on docker container start. SSH client is configured to ignore known ssh hosts.
1. `~/.config/gcloud/` -- is copied from host to dojo's home `~/.config/gcloud` (excpet the logs folder)
2. `~/.gitconfig` -- if exists locally, will be copied
3. `~/.profile` -- will be generated on docker container start, in
   order to ensure current directory is `/dojo/work`.

To enable debug output:
```
OS_DEBUG=1 TF_LOG=debug
```

## Development

### Dependencies
* Bash
* Docker daemon
* Dojo

## License
Copyright 2020 Stephen Judd

Based on https://github.com/kudulab/docker-terraform-dojo
Copyright 2019 Ewa Czechowska, Tomasz Sętkowski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

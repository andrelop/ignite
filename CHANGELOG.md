<!-- Note: This file is autogenerated based on files in docs/releases. Run hack/release.sh to update -->

# Changelog

## v0.4.0

The first release candidate for Ignite's biggest release yet!

There are many significant changes compared to before:

### New Features

 - Make base and kernel OCI images composable for a VM. You can now choose what kernel to combine with what base image freely https://github.com/weaveworks/ignite/pull/105
 - Add the GitOps mode for Ignite using `ignite gitops` https://github.com/weaveworks/ignite/pull/100
   - Documentation: https://github.com/weaveworks/ignite/blob/master/gitops
 - Make it possible to run `ignite create` and `ignite run` declaratively https://github.com/weaveworks/ignite/commit/57333646b52a0e1e3a725340e994b2749b39e5bd
   - Documentation: https://github.com/weaveworks/ignite/blob/master/docs/declarative-config.md
 - Added Prometheus metrics for `ignite-spawn` https://github.com/weaveworks/ignite/commit/94abc529972873db3fa3ee954099a4f62d67b6f3
   - Documentation: https://github.com/weaveworks/ignite/blob/master/docs/prometheus.md
 - Implemented CNI support https://github.com/weaveworks/ignite/commit/a8897532f9f6a8f5c40025f0f93ab2d24f2c7cd3

### API Machinery

 - Added the `ignite.weave.works/v1alpha1` API group with the Ignite API types https://github.com/weaveworks/ignite/commit/ca1edc8e7a61b950811c6145ba2ad53f8cdc2a04
   - API reference: https://github.com/weaveworks/ignite/blob/master/api/ignite.md
   - This API version will not change in a future version. When improvements are made, it will be to `v1alpha2` etc.
 - Add a meta API package containing supporting but generic API types for Ignite https://github.com/weaveworks/ignite/commit/09d51abd409ee361e93884baae24ffc92cde63a9
   - API reference: https://github.com/weaveworks/ignite/blob/master/api/meta.md
 - Create composable interfaces for the internal API machinery: `Client` -> `Cache` -> `Storage` -> `RawStorage` -> `Serializer` https://github.com/weaveworks/ignite/pull/93 https://github.com/weaveworks/ignite/pull/96 https://github.com/weaveworks/ignite/pull/99
 - The API Machinery used in Ignite is partly based on the Kubernetes API machinery (`k8s.io/apimachinery`), and hence follows some of the same patterns

### New Commands

 - Add the `ignite inspect` command https://github.com/weaveworks/ignite/pull/107
 - Add the `ignite gitops` command https://github.com/weaveworks/ignite/pull/100

### Documentation

 - Add user-facing documentation and guides https://github.com/weaveworks/ignite/pull/113
   - See: https://github.com/weaveworks/ignite/tree/master/docs
 - Generate OpenAPI specifications https://github.com/weaveworks/ignite/commit/f1c5bfd473799f712c4c1d8fb276426780c1bf01
   - See: https://github.com/weaveworks/ignite/blob/master/api/openapi/openapi_generated.go
 - Add API type documentation https://github.com/weaveworks/ignite/commit/218c94723f836b8e2cb82886b8664544933ea605
   - See: https://github.com/weaveworks/ignite/blob/master/api
 - Added architecture diagram https://github.com/weaveworks/ignite/commit/da53f9fc2f5790edacb5d1b541dd4da8a6089673
   - See: https://github.com/weaveworks/ignite/blob/master/docs/architecture.png
 - Added graph of module dependencies https://github.com/weaveworks/ignite/commit/be7cc088c671c5728155fb146367a67d4ada4ea6
   - See: https://github.com/weaveworks/ignite/blob/master/docs/dependencies.svg

### Updated Images

#### Base Images

 - `weaveworks/ignite-ubuntu:v0.4.0`: https://github.com/weaveworks/ignite/blob/master/images/ubuntu/Dockerfile
 - `weaveworks/ignite-centos:v0.4.0`: https://github.com/weaveworks/ignite/blob/master/images/centos/Dockerfile
 - `weaveworks/ignite-amazonlinux:v0.4.0`: https://github.com/weaveworks/ignite/blob/master/images/amazonlinux/Dockerfile
 - `weaveworks/ignite-alpine:v0.4.0`: https://github.com/weaveworks/ignite/blob/master/images/alpine/Dockerfile

#### Kernel Images

 - `weaveworks/ignite-kernel:4.14.123`: https://github.com/weaveworks/ignite/blob/master/images/kernel/Dockerfile
 - `weaveworks/ignite-kernel:4.19.47` (default): https://github.com/weaveworks/ignite/blob/master/images/kernel/Dockerfile
 - `weaveworks/ignite-amazon-kernel:v0.4.0` (using `4.14.55`): https://github.com/weaveworks/ignite/blob/master/images/amazon-kernel/Dockerfile

### Internal Improvements

 - A significant refactor of the whole application has been made to support the new API machinery
 - Add structured logging https://github.com/weaveworks/ignite/pull/110
 - Factor out `ignite-spawn` into its own binary running in the container https://github.com/weaveworks/ignite/commit/0a1965e7203877c591dc79504ce257a57fd00480
 - Upgraded the Firecracker version to v0.17.0 https://github.com/weaveworks/ignite/commit/41e3595b9e8d35c24e8cd97037cc1c7045779ee9
 - Set Go version to 1.12.6 https://github.com/weaveworks/ignite/commit/d00cce7d2b09e97f8d515c4a6161b11fc6c61a2c


## Trying it out / Next Steps!

In short:

```bash
export VERSION=v0.4.0
curl -Lo ignite https://github.com/weaveworks/ignite/releases/download/${VERSION}/ignite
chmod +x ignite
sudo mv ignite /usr/local/bin
```

A longer installation guide is available here: https://github.com/weaveworks/ignite/blob/master/docs/installation.md

## v0.3.0

Major release with significant UX and internal improvements:

 - There is no longer a difference between an Ignite image and an OCI image, this is now the same thing.
     - Ignite operates on OCI images directly, for both OS images and kernels. The kernel is expected to be coupled with the image given to `ignite run`, in `/boot/vmlinux`.
 - It is now possible to do `ignite run [OCI image]` directly, and everything (e.g. pulling the image) is handled automatically. e.g. `ignite run -i weaveworks/ignite-ubuntu`.
 - Now `ignite images` shows OCI images that are cached and ready to use, and `ignite kernels` the kernels already imported from base images.
 - Added an example usage guide for running a Kubernetes cluster in HA mode using kubeadm and Ignite.
 - Removed `ignite build`, and `ignite image/kernel import`; as these are no longer needed
 - Importing an image from a tROADMAPar file is no longer possible, package the contents in an OCI image instead
 - Added a new command `ignite ssh [vm]` and flag: `ignite run --ssh`. This allows for automatic SSH logins.
 - Now Ignite logs user-friendly messages by default. To get machine-readable output, use the `--quiet` flag.
 - Ignite now requires the user to be `root`. This will be revisited later, when the architecture has changed.
 - The command outputs and structure is now more user-friendly.
 - Fixed several bugs both under the hood, and user-affecting ones

## v0.2.0

Major release with significant improvements

 - Ignite is now using `devicemapper` under the hood, for overlay snapshots for filesystem writes, allowing for image reuse, efficient use of space and way faster builds!
 - Added sample Ubuntu 18.04 and CentOS 7 OS images & a 4.19 kernel build
 - Automatic network configuration, now the OS image doesn't need to enable DHCP, as that is done in the kernel
 - Automatically populate `/etc/hosts` and `/etc/resolv.conf`, too
 - Add an option to bind a port exposed by the VM to a host port (`ignite run -p 80:80`)
 - Add an option for modifying the kernel command line (`ignite run --kernel-args`)
 - Add an option to copy files from the host into the VM (`ignite run --copy-files`)
 - Add an option to specify the amount of cores, RAM, and overlay size (`ignite run --cpus 2 --memory 1024 --size 4GB`)
 - Removed the need for the Ignite container to run with `--privileged`
 - Allow for force-deletions of images, kernels and vms.
 - Added documentation.
 - Moved repo from `luxas/ignite` to `weaveworks/ignite`

## v0.1.0

This is the first, proof-of-concept version of Ignite.
It has all the essential features, and a pretty complete implementation of the docker UX.


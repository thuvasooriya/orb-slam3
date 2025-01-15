# orb-slam3

this repository is a fork of https://github.com/UZ-SLAMLab/ORB_SLAM3

## goals

- [x] inital flake setup
- [ ] deterministic builds with nix
  - [ ] x86_64-linux - test pending
  - [ ] aarch64-linux - test pending
  - [ ] x86_64-darwin - test pending
  - [x] aarch64-darwin
    - [x] nix develop -> just build
    - [ ] change gui to run on main thread to avoid NSException
    - [ ] nix build
  - [ ] risc v custom cross - only backend

## modifications

- removed old examples
- using clang and c++14 for most of the builds
- database download scripts
- tr1 deprecation modification
- Thirdparty -> deps
- support darwin linked dylib names

## develop instructions

### 1. install nix package manager with flakes and nix-command experimental support

simple nix setup instructions -> https://nixos.org/download/

enable experimental(yet useful and required) features ->
https://nixos.wiki/wiki/Flakes

> optional - install direnv to automatically setup nix devshell when entering
> the directory

### 2. clone the repo and enter directory

### 3. run `nix develop`

> if you have direnv installed you'll need to enter direnv allow to allow the
> flake loading automatically from hereon.

either way after some time it should be in a different shell environment named
`os3-dev-env`

### 4. run `just`

this will list all the available commands. here are some quick commands you can
run immediately

```sh
just build # to build all dependencies and build orbslam3 itself with it's examples
just download_dataset_m1 # to download the sample EuRoC M01 dataset for running example
just ex1 # run a sample example
```

## acknowledgment

- to the original orbslam3 repo
- developers of nix and it's community
- awesome just command runner

## license

- all the respective code belongs to the respective license from the original
  orbslam3 repo.

## Build RD-N2 FVP

```
$ ./build_fvp_rdn2.sh
```

1. Download the FVP_RD_N2

```
export MODEL=/home/infra/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2
```

2. Donwload RD-INFRA Software Stack
```
repo init -u https://git.gitlab.arm.com/infra-solutions/reference-design/infra-refdesign-manifests.git \
```

---
## Launch RD-N2 FVP

```
$ ./launch_fvp_with_ubuntu.sh
```

### launch_fvp_with_ubuntu.sh
```
#!/bin/bash
ROOT_DIR=$(pwd)
WORKSPACE="rd-infra"
WORKSPACE_PATH=$ROOT_DIR/$WORKSPACE
export MODEL=/home/demo/labs/infra/infra_fvp_ann/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2
export DISTRO=ubuntu

cd $WORKSPACE_PATH/model-scripts/rdinfra
./distro.sh -p rdn2 -d $ROOT_DIR/ubuntu.satadisk -n true -a "--parameter board.virtio_net.transport=modern --parameter disable_visualisation=true"
```
---
### Linux boot message

<img src="https://github.com/user-attachments/assets/022002ad-8d94-4096-ae09-b8a6d94f9e37" width=600>

# Getting Started

Reference: https://gitlab.arm.com/infra-solutions/reference-design/docs/infra-refdesign-docs/-/blob/main/docs/user_guides/getting_started.rst?ref_type=heads

---
## Enable Network for FVP's (optional)
If networking is required, the platform FVP's support a virtual ethernet interface that can be configured via TAP mode interface. This mode allows the FVP to be directly connected to the network via a bridge. All ports are
forwarded to the FVP networking interface as if it was connected to the network.

---
## Host Dependencies

Note: This command installs additional packages on the host machine and so the
user is expected to have sufficient privileges on the host machine.

```
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system iproute2
```
---
## Configure TAP Interface
Ensure that the libvirtd service is running
```
sudo systemctl start libvirtd
```

Create a network bridge and change state to up. This step is only required once, so the user can skip if a bridge exists. This example uses virbr0 for the bridge name.
```
sudo ip link add name virbr0 type bridge
sudo ip link set dev virbr0 up
```

Finally, the TAP interface is created, configured and attached to virbr0.
```
sudo ip tuntap add dev tap0 mode tap user $(whoami)
sudo ip link set tap0 promisc on
sudo ip addr add 0.0.0.0 dev tap0
sudo ip link set tap0 up
sudo ip link set tap0 master virbr0
```

This completes the environment setup to have a working workspace so the user can proceed to build, and experiment with Neoverse reference designs features.

---
<img src="https://github.com/user-attachments/assets/067a5681-925e-45ca-ad04-4b2391d42116" width=450>

---
<img src="https://github.com/user-attachments/assets/b2402209-e837-4c0f-9cc7-23b9350411d5" width=800>

---
<img src="https://github.com/user-attachments/assets/c8f8d601-2703-4a71-bab5-a63d6fb16989" width=800>


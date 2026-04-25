# Edge OS — Deployment Guide

## Supported Platforms

| Platform | Defconfig | Notes |
|---|---|---|
| Raspberry Pi 4 | sorabbyngo_edge_arm_defconfig | Primary dev target |
| Raspberry Pi Zero 2W | sorabbyngo_edge_arm_defconfig | Ultra-minimal |
| Drones (Pixhawk) | sorabbyngo_edge_drone_defconfig (planned) | MAVLink |
| Vehicles | sorabbyngo_edge_can_defconfig (planned) | CAN bus |

## Raspberry Pi Setup

```bash
# Flash SD card
dd if=output/images/sorabbyngo-edge.img of=/dev/sdX bs=4M

# First boot — Chameha voice setup wizard
# Set EDGE_TYPE in /etc/sorabbyngo/edge-os.conf
```

## Byngonet Mesh

Edge devices automatically join the nearest Sorabbyngo mesh node.
No configuration needed — NodeID-based identity is hardware-bound.

```bash
# Check mesh status
python3 /opt/sorabbyngo/byngonet/node/byngonet_node.py --status
```

## Monitor Gateway (Ward Devices)

```bash
export WARD="ICU-A" BED="BED-1"
export NATS_URL="nats://hospital-server:4222"
python3 /opt/sorabbyngo/novela-monitors/gateway/main.py
```

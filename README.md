<p align="center">
  <img src="https://raw.githubusercontent.com/sorabbyngo-Labs/.github/main/assets/sorabbyngo-logo.jpg" alt="Sorabbyngo" width="480"/>
</p>

<p align="center">
  <strong>Edge OS — IoT, Drones, Vehicles & Embedded Systems</strong>
</p>

<p align="center">
  Built on Sorabbyngo AI Kernel · Minimal footprint · Real-time · CAN bus
</p>

---

## What this is

Edge OS is the embedded surface of the Sorabbyngo AI Kernel. It runs on drones, vehicles, smart city nodes, IoT sensors, and robotics platforms.

Every Edge OS device is a Byngonet node — part of the AI mesh.

---

## Key Requirements

| Requirement | Implementation |
|---|---|
| Minimal footprint | Target under 50MB rootfs |
| Real-time control | PREEMPT_RT for actuator control |
| Vehicle support | CAN bus (SocketCAN) |
| Drone support | MAVLink protocol |
| Edge AI | TinyLLM / QLoRA compressed models |
| Mesh networking | Byngonet node — WiFi Direct + LoRa |

---

## Target Platforms

| Platform | Architecture | Status |
|---|---|---|
| Drones | ARM Cortex-A / M | Planned |
| Vehicles | ARM64 + CAN | Planned |
| Smart city nodes | x86_64 / ARM64 | Planned |
| IoT sensors | ARM Cortex-M | Planned |
| Robotics | ARM64 | Planned |
| Raspberry Pi | ARM64 | Planned |

---

## Relationship to Sorabbyngo Kernel
sorabbyngo-os (kernel source)
└── configs/sorabbyngo_edge_arm_defconfig
└── edge-os (this repo — minimal rootfs + MAVLink + CAN)
---

## Related Repositories

| Repo | Role |
|---|---|
| [sorabbyngo-os](https://github.com/sorabbyngo-Labs/sorabbyngo-os) | Kernel source |
| [byngonet](https://github.com/sorabbyngo-Labs/byngonet) | Mesh network protocol |
| [byngox](https://github.com/sorabbyngo-Labs/byngox) | Edge AI reasoning |

---

**Sorabbyngo Company** · Kisii, Kenya · 2026
*Rhythm of Digital Life*

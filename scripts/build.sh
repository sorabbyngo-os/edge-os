#!/usr/bin/env bash
# Edge OS — Minimal Embedded Image Builder
set -euo pipefail

YELLOW='\033[1;33m'; CYAN='\033[0;36m'; GREEN='\033[0;32m'; NC='\033[0m'; BOLD='\033[1m'
info()    { echo -e "${CYAN}[edge-os]${NC} $*"; }
success() { echo -e "${GREEN}[edge-os]${NC} $*"; }
warn()    { echo -e "${YELLOW}[edge-os]${NC} $*"; }

KERNEL_SRC="${KERNEL_SRC:-$HOME/sorabbyngo-os}"
DEFCONFIG="sorabbyngo_edge_arm_defconfig"
OUTPUT="${OUTPUT:-$HOME/edge-os/build}"
PROFILE="${PROFILE:-drone}"   # drone | vehicle | iot | rpi

echo -e "${BOLD}"
cat << 'BANNER'
  ╔══════════════════════════════════════╗
  ║   Edge OS — Embedded Image Builder   ║
  ║   Minimal · Real-time · CAN/MAVLink  ║
  ╚══════════════════════════════════════╝
BANNER
echo -e "${NC}"

[[ ! -d "$KERNEL_SRC" ]] && { warn "Kernel source not at $KERNEL_SRC"; exit 1; }

info "Profile: $PROFILE"
info "Applying edge defconfig (PREEMPT_RT ARM)..."
cp defconfig/$DEFCONFIG "$KERNEL_SRC/arch/arm64/configs/"
make -C "$KERNEL_SRC" $DEFCONFIG

# Profile-specific overlays
case "$PROFILE" in
    drone)
        info "Drone profile — MAVLink + GPS + IMU drivers"
        cat >> "$KERNEL_SRC/arch/arm64/configs/$DEFCONFIG" << 'DRONE'
CONFIG_MAVLINK=y
CONFIG_SENSORS_BMI088=y
CONFIG_GPS_UBLOX=y
DRONE
        ;;
    vehicle)
        info "Vehicle profile — CAN bus + OBD2"
        cat >> "$KERNEL_SRC/arch/arm64/configs/$DEFCONFIG" << 'VEH'
CONFIG_CAN=y
CONFIG_CAN_SOCKETCAN=y
CONFIG_CAN_MCP251X=y
VEH
        ;;
    iot)
        info "IoT profile — LoRa + minimal footprint"
        ;;
    rpi)
        info "Raspberry Pi profile"
        ;;
esac

info "Building minimal kernel..."
make -C "$KERNEL_SRC" -j$(nproc) Image.gz dtbs modules

info "Overlaying Edge OS rootfs..."
mkdir -p "$OUTPUT"
cp -r rootfs/* "$OUTPUT/"

info "Installing systemd units for profile: $PROFILE"
cp rootfs/etc/systemd/system/byngonet-edge.service "$OUTPUT/etc/systemd/system/"
cp rootfs/etc/systemd/system/cyberwall-edge.service "$OUTPUT/etc/systemd/system/"
cp rootfs/etc/systemd/system/edge-ai.service "$OUTPUT/etc/systemd/system/"
cp rootfs/etc/systemd/system/edge.target "$OUTPUT/etc/systemd/system/"

[[ "$PROFILE" == "drone" ]]   && cp rootfs/etc/systemd/system/mavlink-bridge.service "$OUTPUT/etc/systemd/system/"
[[ "$PROFILE" == "vehicle" ]] && cp rootfs/etc/systemd/system/can-gateway.service "$OUTPUT/etc/systemd/system/"

systemctl --root="$OUTPUT" enable byngonet-edge.service cyberwall-edge.service edge-ai.service
systemctl --root="$OUTPUT" set-default edge.target

# Size check
ROOTFS_MB=$(du -sm "$OUTPUT" | cut -f1)
info "Rootfs size: ${ROOTFS_MB}MB (target: <50MB)"
[[ $ROOTFS_MB -gt 50 ]] && warn "Rootfs exceeds 50MB target — review included packages"

success "Edge OS ($PROFILE) image ready at $OUTPUT"

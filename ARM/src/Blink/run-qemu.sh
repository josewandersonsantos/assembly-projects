#!/bin/bash
echo "=== QEMU GDB Server starting... ==="
qemu-system-arm -M stm32vldiscovery -cpu cortex-m3 -kernel main.elf -nographic -S -gdb tcp::1234 "$@"
echo "=== QEMU Server started ==="
exit 0
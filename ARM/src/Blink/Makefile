qemu-build: qemu-clean
# 	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -nostdlib -T memory.ld main.s -o main.elf
	arm-none-eabi-gcc -g -Og -Wall -Wextra -mcpu=cortex-m3 -mthumb -nostdlib -T memory.ld main.s -o main.elf -Wl,--gc-sections
# 	arm-none-eabi-objdump -D main.elf

qemu-run: qemu-build qemu-stop
	qemu-system-arm -M stm32vldiscovery -cpu cortex-m3 -kernel main.elf -nographic -S -gdb tcp::1234
# 	qemu-system-arm -M stm32vldiscovery -cpu cortex-m3 -kernel main.elf -nographic -gdb tcp::1234
# 	qemu-system-arm -M stm32vldiscovery -cpu cortex-m3 -nographic -S -gdb tcp::1234 -device loader,file=main.elf,addr=0x08000000

qemu-stop:
	pkill "qemu-system-arm" > /dev/null 2>&1 || true

qemu-clean:
	rm -f *.o *.elf

make-bin:
	objcopy -O binary main.elf main.bin
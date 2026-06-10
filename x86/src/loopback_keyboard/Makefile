init:
	echo "- Building loopback keyboard..."
	nasm -f elf32 loopback_keyboard.asm -o loopback_keyboard.o
	ld -m elf_i386 loopback_keyboard.o -o loopback_keyboard
	chmod u+x loopback_keyboard
clean:
	echo "- Cleaning up..."
	rm -f loopback_keyboard.o loopback_keyboard

run: init
	echo "- Running loopback keyboard..."
	./loopback_keyboard
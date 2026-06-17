init:
	nasm -felf32 -F dwarf -g conditional.s -o conditional.o
	ld -m elf_i386 conditional.o -o conditional
run: init
	./conditional
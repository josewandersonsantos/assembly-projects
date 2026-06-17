init:
	nasm -f elf32 -F dwarf -g calculator.asm -o calculator.o
	ld -m elf_i386 calculator.o -o calculator
	chmod u+x calculator
run: init
	./calculator
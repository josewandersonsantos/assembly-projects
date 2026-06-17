init:
	nasm -f elf32 print_sequence.s -o print_sequence.o
	ld -m elf_i386 print_sequence.o -o print_sequence
run:
	nasm -f elf32 print_sequence.s -o print_sequence.o
	ld -m elf_i386 print_sequence.o -o print_sequence
	./print_sequence
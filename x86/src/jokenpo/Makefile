init:
	nasm -f elf32 -F dwarf -g jokenpo.asm -o jokenpo.o
	ld -m elf_i386 jokenpo.o -o jokenpo
	chmod u+x jokenpo
run: init
	./jokenpo
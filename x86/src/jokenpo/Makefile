init:
	nasm -f elf32 -F dwarf -g jokenpo.asm -o jokenpo.o 
	nasm -f elf32 -F dwarf -g random.asm -o random.o 
	ld -m elf_i386 jokenpo.o random.o -o jokenpo
	chmod u+x jokenpo
run: init
	./jokenpo
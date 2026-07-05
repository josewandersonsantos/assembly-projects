init:
	nasm -f elf32 -F dwarf -g create_file.asm -o create_file.o
	ld -m elf_i386 create_file.o -o create_file.exe
	chmod u+x create_file.exe
run: init
	./create_file.exe
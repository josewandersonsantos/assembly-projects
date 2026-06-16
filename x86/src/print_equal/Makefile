build:
	nasm -felf32 print_equal.s -o print_equal.o
	ld -m elf_i386 print_equal.o -o print_equal

clean:
	rm -rf print_equal.o print_equal

run:
	./print_equal
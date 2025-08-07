test_link: new_func.o main.o
	ld -o $@ $^

%.o: %.s
	as --64 --gstabs -o $@ $^

.phony: clean

clean:
	rm *.o test_link
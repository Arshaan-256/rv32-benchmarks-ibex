clean:
	rm -f */*.x
	rm -f */*.map
	rm -f */*.new

assemble:
	python3 riscv_assembler.py

fix:
	python3 riscv_assembler.py --mode=FIX

replace: 
	rm -f $(FILE).d
	mv $(FILE).new $(FILE).d


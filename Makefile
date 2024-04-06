## OK!
FILE := program.s

help:     ## Show this help.
	sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

clean: #OK.
	rm -f program.x
	rm -f program.map
# rm -f *.x
# rm -f *.map
# rm -f *.new
# rm -f */*.x
# rm -f */*.map
# rm -f */*.new

assemble:
## Run second pass of the assembler.
	python3 riscv_assembler.py --mode=ASSEMBLE --file=$(FILE)

fix:
	python3 riscv_assembler.py --mode=FIX --file=$(FILE)

replace: 
	if [ -f $(FILE).new ]; then \
		echo 'File replaced.'; \
		rm -f $(FILE).d; \
		mv $(FILE).new $(FILE); \
	else \
		echo 'File does not exist.'; \
	fi

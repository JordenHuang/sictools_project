
ss	START	0
first
	. JSUB	gene
	JSUB	init

	LDX	#0

	STA	pos
	LDA	#255

	STCH	@pos
halt	J	halt

init
	LDA		gscrn
	STA 	pos
	LDS		scrow
	LDT 	sccol
	LDB	#5	. 5th row, y = 5
	. MULR	B,T	. y * cols
	. ADDR	T,S	. + x
	. ADDR	S,A	. gscrn + postion = final position
	STA	pos	. and store from reg A to pos
	RSUB

gene
	LDX 	#0
	.counter
	LDB 	#0
	LDA 	#5
	LDT 	sccol
	LDS 	scrow
	MULR 	S,T
	STT 	pixels
	CLEAR 	T
	CLEAR 	S


... Data part
pixels	WORD 	0
pos	WORD	0
. dot_pos	RESW	40
gscrn	WORD	X'00A000'
scrow	WORD	64
sccol	WORD	64

	END	ss
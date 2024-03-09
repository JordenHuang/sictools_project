
test	START	0
	LDA	b
	FLOAT
	STF	f_b
	LDF	#1
	DIVF	f_b
	STF	result
	. FIX
halt	J	halt


f_a	RESF	1
f_b	RESF	1
b	WORD	2
result	RESF	1

	END	test
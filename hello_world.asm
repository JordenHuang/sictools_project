test	START	0
	CLEAR	X
print	TD	stdout
	JEQ	print
	LDCH	hw, X
	WD	stdout
	TIX	len
	JLT	print
halt	J	halt

hw	BYTE	C'hello world'
len	WORD	11
stdout	BYTE	1
	END	test
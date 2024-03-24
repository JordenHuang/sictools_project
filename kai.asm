TEST	START       0           .程式名稱test
QQ	TD     INPUT
	JEQ     QQ
	RD     INPUT
	STCH     TE

PLOOP	TD     OUTPUT
	JEQ     PLOOP
	LDCH     TE
	WD     OUTPUT
	. LDCH        INPUT
	COMP        #51
	JEQ         THEEND
	. J           PLOOP
	JSUB        QQ

THEEND	STCH       TE
	. JSUB        QQ
halt	J	halt
	END         QQ


.
.
TE	RESB    1
. ONE	BYTE    C'1'
ONE	WORD	49
.PRINT1  RESB    C'input a string:'
TREE	RESB    256
INPUT	BYTE    0
OUTPUT	BYTE    1
.KEYBOR  BYTE    X'0C000'
.TEXTSC  BYTE    X'0B800'
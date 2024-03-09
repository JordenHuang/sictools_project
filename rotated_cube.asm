
... rc for rotated cube
rc	START	0
	JSUB	variable_init

	LDA	#314
	FLOAT
	DIVF	#100
	STF	float_x
	JSUB	cos_func
halt	J	halt



sin_func	LDF	float_x
		MULF	float_x		... F = float_x ^ 2
		STF	float_sqare_x	... float_sqare_x = float_x ^ 2
		LDF	float_x
		MULF	float_sqare_x	... F = float_x ^ 3
		STF	float_temp	... float_temp = float_x ^ 3
		DIVF	#6
		STF	float_term_2	... float_term_2 = (float_x ^ 3) / (3!)
		LDF	float_temp
		MULF	float_sqare_x	... F = F = float_x ^ 5
		DIVF	#120
		. DIVF	#7		... 720 * 7 = 7!
		STF	float_term_3	... float_term_3 = (float_x ^ 5) / (5!)

		LDF	float_x
		SUBF	float_term_2
		ADDF	float_term_3
		RSUB

cos_func	LDF	float_x
		MULF	float_x		... F = float_x ^ 2
		STF	float_sqare_x	... float_sqare_x = float_x ^ 2
		DIVF	#2
		STF	float_term_2	... float_term_2 = (float_x ^ 2) / (2!)
		LDF	float_sqare_x
		MULF	float_sqare_x	... F = float_^ 4
		STF	float_temp	... float_temp = float ^ 4
		DIVF	#24		... 4!
		STF	float_term_3	... float_term_3 = (float_x ^ 4) / (4!)
		LDF	float_temp
		MULF	float_sqare_x	... F = float_x ^ 6
		STF	float_temp	... float_temp = float ^ 6
		DIVF	#720		... 6!
		STF	float_term_4	... float_term_4 = (float_x ^ 6) / (6!)
		LDF	float_temp
		MULF	float_sqare_x	... F = float_x ^ 8
		DIVF	#720
		DIVF	#56		... 720 * 56 = 8!
		STF	float_term_5	... float_term_5 = (float_x ^ 8) / (8!)

		LDF	#1
		SUBF	float_term_2
		ADDF	float_term_3
		SUBF	float_term_4
		ADDF	float_term_5
		RSUB




variable_init	CLEAR	A
		FLOAT
		... set angle_* to 0
		STF	angle_a
		STF	angle_b
		STF	angle_c

		... set rotate_speed to
		... 0.05, 0.05, 0.01
		... to rotate_speed_for_{x, y, z}
		LDF	#5
		DIVF	#100
		STF	rotate_speed_for_x
		STF	rotate_speed_for_y

		DIVF	#5
		STF	rotate_speed_for_z
		RSUB


......
... Variables
......
screen_start	WORD	X'00A000'
screen_rows	WORD	64
screen_cols	WORD	64

... 
. check_front_symbols	RESW	64

... colors
bg_color	WORD	X'00'	... color black
f_color		WORD	X'CC'	... color green
b_color		WORD	X'D7'	... color blue
r_color		WORD	X'F0'	... color red
l_color		WORD	X'F8'	... color orange
u_color		WORD	X'FF'	... color white
d_color		WORD	X'FC'	... color yellow

position	WORD	1

... float number part
rotate_speed_for_x	RESF	1
rotate_speed_for_y	RESF	1
rotate_speed_for_z	RESF	1

... coordinate
x 	RESF	1
y 	RESF	1
z 	RESF	1

... angle
angle_a 	RESF	1
angle_b 	RESF	1
angle_c 	RESF	1

... variables for calculation
float_temp	RESF	1
float_x		RESF	1
float_sqare_x	RESF	1
float_term_2	RESF	1	... 多項式第二項
float_term_3	RESF	1	... 多項式第三項
float_term_4	RESF	1	... 多項式第四項
float_term_5	RESF	1	... 多項式第五項
float_result	RESF	1

	END	rc
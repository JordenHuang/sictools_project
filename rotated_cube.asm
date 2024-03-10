... Note at 2024/03/09
... need two matrices, storing colors and z values
... initialize them to all black and all zero, like memset function in c

... rc for rotated cube
rc	START	0
	JSUB	variable_init

	JSUB	main

... test cos function
	. LDA	#314
	. FLOAT
	. DIVF	#100
	. STF	f_x
	. JSUB	cos_func

... test calculate_x function
	. LDF	#22
	. STF	f_cube_x
	. STF	f_cube_y
	. STF	f_cube_z
	. JSUB	calculate_sins_and_coss
	. JSUB	calculate_x

halt	J	halt


main	STL	temp_L
	JSUB	memset_colors
	JSUB	memset_f_ch_fnt_pos




... colors memset subrutine
memset_colors		LDX	#0
			LDS	bg_color
			STS	colors, X
			TIX	#4095
			JLT	memset_colors
			RSUB

... f_check_front_pos memset subrutine
memset_f_ch_fnt_pos	LDX	#0
			LDF	#0
			STF	f_check_front_pos, X
			LDA	#4
			ADDR	A, X
			COMP	#4095
			JLT	memset_f_ch_fnt_pos
			RSUB


... subrutine for calculate cube surface
calculate_cube_surface	STL	temp_L
			JSUB	calculate_sins_and_coss
			JSUB	calculate_x	... it will read f_cube_{x, y, z}, and calc them
			LDF	f_result
			STF	f_coor_x	... calc f_coor_x's value
			FIX
			STA	int_coor_x	... store it to int_coor_x

			JSUB	calculate_y
			STF	f_coor_y	... calc f_coor_y's value

			JSUB	calculate_z
			STF	f_coor_z	... calc f_coor_z's value

			LDF	f_coor_y
			DIVF	#2
			FIX			... turn f_coor_y into int y
			STA	int_coor_y	... store it to int_coor_y

			LDA	original_point_y
			SUB	int_coor_y
			MUL	screen_cols
			ADD	original_point_x
			ADD	int_coor_x	... position = (22-y)*100 + 50-(-x);

			... Continue here (3/10) ...
			STA	position
			LDX	position
			LDB	#4
			MULR	B, X		... multiply 4 because f_check_front_pos's type is float
			LDA	f_check_front_pos, X
			COMP	#0		... if (check_front_symbols[position]==0)
			JEQ	equal_zero_or_greater_z
			COMP	f_coor_z	... else (check_front_symbols[position] > z)
			JGT	equal_zero_or_greater_z
			J	calculate_cube_surface_return
equal_zero_or_greater_z	LDS	f_coor_z
			STS	f_check_front_pos, X
			DIVR	B, X		... divide 4 because colors matrix is type byte
			LDS	cur_color
			STS	colors, X	... write color to colors matrix
			J	calculate_cube_surface_return
calculate_cube_surface_return
			LDL	temp_L
			RSUB



... subrutine for calculate sins and coss to f_angle_{a, b, c}
calculate_sins_and_coss	STL	temp_L		... store L to temp_L
			... sins
			LDF	f_angle_a
			STF	f_x
			JSUB	sin_func	... calc sin(f_angle_a),
			LDF	f_result
			STF	sin_f_angle_a	... store it to sin_f_angle_a

			LDF	f_angle_b
			STF	f_x
			JSUB	sin_func	... calc sin(f_angle_b),
			LDF	f_result
			STF	sin_f_angle_b	... store it to sin_f_angle_b

			LDF	f_angle_c
			STF	f_x
			JSUB	sin_func	... calc sin(f_angle_c),
			LDF	f_result
			STF	sin_f_angle_c	... store it to sin_f_angle_c

			... coss
			LDF	f_angle_a
			STF	f_x
			JSUB	cos_func	... calc cos(f_angle_a),
			LDF	f_result
			STF	cos_f_angle_a	... store it to sin_f_angle_a

			LDF	f_angle_b
			STF	f_x
			JSUB	cos_func	... calc cos(f_angle_b),
			LDF	f_result
			STF	cos_f_angle_b	... store it to sin_f_angle_b

			LDF	f_angle_c
			STF	f_x
			JSUB	cos_func	... calc cos(f_angle_c),
			LDF	f_result
			STF	cos_f_angle_c	... store it to sin_f_angle_c

			LDL	temp_L		... put temp_L to register L
			RSUB


calculate_x	LDF	f_cube_x
		MULF	cos_f_angle_b
		MULF	cos_f_angle_c
		STF	f_term_1	... f_term_1 = x*cos(b)*cos(c)
		LDF	f_cube_y
		MULF	cos_f_angle_b
		MULF	sin_f_angle_c
		STF	f_term_2	... f_term_2 = y*cos(b)*sin(c)
		LDF	f_cube_z
		MULF	sin_f_angle_b
		STF	f_term_3	... f_term_3 = z*sin(b)
		
		LDF	f_term_1
		SUBF	f_term_2
		ADDF	f_term_3
		STF	f_result
		RSUB

calculate_y	LDF	sin_f_angle_a
		MULF	sin_f_angle_b
		MULF	cos_f_angle_c
		STF	f_temp		... f_temp = sin(a)*sin(b)*cos(c)
		LDF	cos_f_angle_a
		MULF	sin_f_angle_c	... F = cos(a)*sin(c)
		ADDF	f_temp		... F = F + f_temp
		MULF	f_cube_x	
		STF	f_term_1	... f_term_1 = x*(sin(a)*sin(b)*cos(c) + cos(a)*sin(c))
		LDF	cos_f_angle_a
		MULF	cos_f_angle_c
		STF	f_temp		... f_temp = cos(a)*cos(c)
		LDF	sin_f_angle_a
		MULF	sin_f_angle_b
		MULF	sin_f_angle_c
		STF	f_temp_2	... f_temp_2 = sin(a)*sin(b)*sin(c)
		LDF	f_cube_y
		MULF	f_temp
		MULF	f_temp_2
		STF	f_term_2	... f_term_2 = y*(cos(a)*cos(c)- sin(a)*sin(b)*sin(c))
		LDF	f_cube_z
		MULF	sin_f_angle_a
		MULF	cos_f_angle_b
		STF	f_term_3	... f_term_3 = z*sin(a)*cos(b)

		LDF	f_term_1
		ADDF	f_term_2
		SUBF	f_term_3
		STF	f_result	...
		RSUB

calculate_z	LDF	sin_f_angle_a
		MULF	sin_f_angle_c
		STF	f_temp		... f_temp = sin(a)*sin(c)
		LDF	cos_f_angle_a
		MULF	sin_f_angle_b
		MULF	cos_f_angle_c
		STF	f_temp_2	... f_temp_2 = cos(a)*sin(b)*cos(c)
		LDF	f_temp
		SUBF	f_temp_2
		MULF	f_cube_x
		STF	f_term_1	... f_term_1 = (sin(a)*sin(c) - cos(a)*sin(b)*cos(c))*x
		LDF	cos_f_angle_a
		MULF	sin_f_angle_b
		MULF	sin_f_angle_c
		STF	f_temp		... f_temp = cos(a)*sin(b)*sin(c)
		LDF	sin_f_angle_a
		MULF	cos_f_angle_c	... F = sin(a)*cos(c)
		ADDF	f_temp		... F = F + f_temp
		MULF	f_cube_y	... F = (F + f_temp) * y
		STF	f_term_2	... f_term_2 = F
		LDF	f_cube_z
		MULF	sin_f_angle_a
		MULF	cos_f_angle_b
		STF	f_term_3	... f_term_3 = cos(a)*cos(b)*z

		LDF	f_term_1
		ADDF	f_term_2
		ADDF	f_term_3
		RSUB




sin_func	LDF	f_x
		MULF	f_x		... F = f_x ^ 2
		STF	f_sqare_x	... f_sqare_x = f_x ^ 2
		LDF	f_x
		MULF	f_sqare_x	... F = f_x ^ 3
		STF	f_temp	... f_temp = f_x ^ 3
		DIVF	#6
		STF	f_term_2	... f_term_2 = (f_x ^ 3) / (3!)
		LDF	f_temp
		MULF	f_sqare_x	... F = F = f_x ^ 5
		DIVF	#120
		. DIVF	#7		... 720 * 7 = 7!
		STF	f_term_3	... f_term_3 = (f_x ^ 5) / (5!)

		LDF	f_x
		SUBF	f_term_2
		ADDF	f_term_3
		STF	f_result	... store the result to f_result
		RSUB

cos_func	LDF	f_x
		MULF	f_x		... F = f_x ^ 2
		STF	f_sqare_x	... f_sqare_x = f_x ^ 2
		DIVF	#2
		STF	f_term_2	... f_term_2 = (f_x ^ 2) / (2!)
		LDF	f_sqare_x
		MULF	f_sqare_x	... F = f_^ 4
		STF	f_temp	... f_temp = f ^ 4
		DIVF	#24		... 4!
		STF	f_term_3	... f_term_3 = (f_x ^ 4) / (4!)
		LDF	f_temp
		MULF	f_sqare_x	... F = f_x ^ 6
		STF	f_temp	... f_temp = f ^ 6
		DIVF	#720		... 6!
		STF	f_term_4	... f_term_4 = (f_x ^ 6) / (6!)
		LDF	f_temp
		MULF	f_sqare_x	... F = f_x ^ 8
		DIVF	#720
		DIVF	#56		... 720 * 56 = 8!
		STF	f_term_5	... f_term_5 = (f_x ^ 8) / (8!)

		LDF	#1
		SUBF	f_term_2
		ADDF	f_term_3
		SUBF	f_term_4
		ADDF	f_term_5
		STF	f_result	... store the result to f_result
		RSUB




variable_init	CLEAR	A
		FLOAT
		... set angle_* to 0
		STF	f_angle_a
		STF	f_angle_b
		STF	f_angle_c

		... set rotate_speed to
		... 0.05, 0.05, 0.01
		... to f_rotate_speed_for_{x, y, z}
		LDF	#5
		DIVF	#100
		STF	f_rotate_speed_for_x
		STF	f_rotate_speed_for_y

		DIVF	#5
		STF	f_rotate_speed_for_z

		... set cube width to 28
		LDF	#28
		STF	f_cube_width

		... set original_point_{x, y} to half screen width and column
		LDA	screen_rows
		DIV	#2
		STA	original_point_y
		LDA	screen_cols
		DIV	#2
		STA	original_point_x
		RSUB


......
... Constants
......
screen_start	WORD	X'00A000'
screen_rows	WORD	64
screen_cols	WORD	64

... colors
bg_color	WORD	X'00'	... color black
f_color		WORD	X'CC'	... color green
b_color		WORD	X'D7'	... color blue
r_color		WORD	X'F0'	... color red
l_color		WORD	X'F8'	... color orange
u_color		WORD	X'FF'	... color white
d_color		WORD	X'FC'	... color yellow



......
... Variables
......
original_point_x	RESW	1
original_point_y	RESW	1

position		RESW	1

cur_color		RESW	1

... matrices for colors and front pos
colors			RESB	4096
... the type is float
... WARNING: this matrix might need to add
... 4 when indexing
f_check_front_pos	RESF	4096


temp_L		RESW	1

int_coor_x	RESW	1
int_coor_y	RESW	1
int_coor_z	RESW	1

... float number part
f_cube_width	RESF	1

f_cube_x	RESF	1
f_cube_y	RESF	1
f_cube_z	RESF	1

f_rotate_speed_for_x	RESF	1
f_rotate_speed_for_y	RESF	1
f_rotate_speed_for_z	RESF	1

... coordinate
f_coor_x 	RESF	1
f_coor_y 	RESF	1
f_coor_z 	RESF	1

... angle
f_angle_a 	RESF	1
f_angle_b 	RESF	1
f_angle_c 	RESF	1

... the result of sin( f_angle_{a, b, c} )
sin_f_angle_a	RESF	1
sin_f_angle_b	RESF	1
sin_f_angle_c	RESF	1

... the result of cos( f_angle_{a, b, c} )
cos_f_angle_a	RESF	1
cos_f_angle_b	RESF	1
cos_f_angle_c	RESF	1

... variables for calculation
f_temp		RESF	1
f_temp_2	RESF	1
f_x		RESF	1
f_y		RESF	1
f_z		RESF	1
f_sqare_x	RESF	1
f_term_1	RESF	1	... 
f_term_2	RESF	1	... 多項式第二項
f_term_3	RESF	1	... 多項式第三項
f_term_4	RESF	1	... 多項式第四項
f_term_5	RESF	1	... 多項式第五項
f_result	RESF	1

	END	rc
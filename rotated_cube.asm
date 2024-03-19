... Note at 2024/03/09
... need two matrices, storing colors and z values
... initialize them to all black and all zero, like memset function in c

... Note at 2024/03/10
... sin, cos, calculate_sins_and_cos are correct
... memset_colors, memset_f_ch_fnt_pos are correct
... write_to_screen is correct
...  the angle can't be greater than 360, need to shrink them
... try: 大於360就減360(3.14), -3.14 ~ 3.14
...  maybe need a temp_f_cube_{x, y, z} to easy swap those value to calculate the surface?

... Note at 2024/03/11
... Accomplished! TODO: maybe calculate_sins_and_coss can be called only once in main_n, rather than each calculate surface
... Accomplished! TODO: make sin and cos more accurate

... rc for rotated cube
rc	START	0
	JSUB	variable_init

	JSUB	main

... test cos function
	. LDA	#166
	. FLOAT
	. DIVF	#100
	. STF	f_x
	. JSUB	cos_func

... test calculate_{x, y, z} functions
	. LDF	#10
	. MULF	f_negative_one
	. STF	f_cube_x
	. STF	f_cube_y
	. STF	f_cube_z
	. JSUB	calculate_sins_and_coss
	. . JSUB	calculate_x
	. . JSUB	calculate_y
	. JSUB	calculate_z

halt	J	halt
. halta	J	halta

main		STL	temp_L_3
main_n		JSUB	memset_colors
		JSUB	memset_f_ch_fnt_pos
			JSUB	calculate_sins_and_coss

double_loop	LDF	f_half_cube_width
		MULF	f_negative_one
		STF	fy		... fx and fy is used as loop variables
outer_loop	LDF	f_half_cube_width
		MULF	f_negative_one
		STF	fx
inner_loop	LDF	fx
		STF	f_cube_x
		LDF	fy
		STF	f_cube_y	... f_cube_y's value
		LDF	f_half_cube_width
		MULF	f_negative_one
		STF	f_cube_z
		. CLEAR	A
		LDCH	f_color		... f side cube color
		STCH	cur_color
		JSUB	calculate_cube_surface	... f side cube

		LDF	fx
		STF	f_cube_x
		LDF	fy
		STF	f_cube_y
		LDF	f_half_cube_width
		STF	f_cube_z
		. CLEAR	A
		LDCH	b_color		... b side cube color
		STCH	cur_color
		JSUB	calculate_cube_surface	... b side cube

		LDF	f_half_cube_width
		MULF	f_negative_one
		STF	f_cube_x
		LDF	fy
		STF	f_cube_y
		LDF	fx
		STF	f_cube_z
		. CLEAR	A
		LDCH	l_color		... l side color
		STCH	cur_color
		JSUB	calculate_cube_surface	... l side cube

		LDF	f_half_cube_width
		STF	f_cube_x
		LDF	fy
		STF	f_cube_y
		LDF	fx
		STF	f_cube_z
		. CLEAR	A
		LDCH	r_color		... r side color
		STCH	cur_color
		JSUB	calculate_cube_surface	... r side cube

		LDF	fx
		STF	f_cube_x
		LDF	f_half_cube_width
		MULF	f_negative_one
		STF	f_cube_y
		LDF	fy
		STF	f_cube_z
		. CLEAR	A
		LDCH	d_color		... d side color
		STCH	cur_color
		JSUB	calculate_cube_surface	... d side cube

		LDF	fx
		STF	f_cube_x
		LDF	f_half_cube_width
		STF	f_cube_y
		LDF	fy
		STF	f_cube_z
		. CLEAR	A
		LDCH	u_color		... u side color
		STCH	cur_color
		JSUB	calculate_cube_surface	... u side cube

		LDF	#5
		DIVF	#10
		ADDF	fx
		STF	fx		... f_x += 0.5
		COMPF	f_inner_loop_condition	... f_x <= cube_width/2
		JLT	inner_loop
		JEQ	inner_loop

		LDF	#5
		DIVF	#10
		ADDF	fy
		STF	fy		... fy += 0.5
		COMPF	f_outer_loop_condition	... fy <= cube_width/2 
		JLT	outer_loop
		JEQ	outer_loop
		JSUB	write_to_screen

		... add angle to rotate
a_check		LDF	f_rotate_speed_for_x
		ADDF	f_angle_a
		COMPF	pi
		JGT	a_chk_in_range
		JEQ	a_chk_in_range
		STF	f_angle_a
		J	b_check
. a_turn_nega	MULF	f_negative_one
a_chk_in_range 	SUBF	pi
		SUBF	pi
		STF	f_angle_a

b_check		LDF	f_rotate_speed_for_y
		ADDF	f_angle_b
		COMPF	pi
		JGT	b_chk_in_range
		JEQ	b_chk_in_range
		STF	f_angle_b
		J	c_check
. b_chk_in_range	MULF	f_negative_one
b_chk_in_range	SUBF	pi
		SUBF	pi
		STF	f_angle_b

c_check		LDF	f_rotate_speed_for_z
		ADDF	f_angle_c
		COMPF	pi
		JGT	c_chk_in_range
		JEQ	c_chk_in_range
		STF	f_angle_c
		J	main_n
. c_turn_nega	MULF	f_negative_one
c_chk_in_range	SUBF	pi
		SUBF	pi
		STF	f_angle_c
		J	main_n


write_to_screen	STL	temp_L_4
		LDX	#0
		+LDS	#4096
wts_for		LDT	screen_start
		. CLEAR	A
		LDCH	colors, X	... load the color to write
		. LDCH	f_color
		ADDR	X, T
		STT	position
		STCH	@position

		TIXR	S
		JLT	wts_for

		LDL	temp_L_4
		RSUB


... colors memset subrutine
memset_colors		LDX	#0
mc_for			LDCH	bg_color
			STCH	colors, X
			+TIX	#4096
			JLT	mc_for
			RSUB

... f_check_front_pos memset subrutine
memset_f_ch_fnt_pos	LDX	#0
			LDT	#6
			LDA	#0
			+LDS	#4096
			LDF	#0
mfcfp_for		STF	f_check_front_pos, X
			ADDR	T, X
			ADD	#1

			COMPR	A, S
			JLT	mfcfp_for
			RSUB


... subrutine for calculate cube surface
calculate_cube_surface	STL	temp_L_2
			JSUB	calculate_x	... it will read f_cube_{x, y, z}, and calc them
			LDF	f_result
			STF	f_coor_x	... calc f_coor_x's value
			FIX
			STA	int_coor_x	... store it to int_coor_x

			JSUB	calculate_y
			LDF	f_result
			STF	f_coor_y	... calc f_coor_y's value
			FIX
			STA	int_coor_y	... store it to int_coor_y

			JSUB	calculate_z
			LDF	f_result
			STF	f_coor_z	... calc f_coor_z's value
			FIX
			STA	int_coor_z	... store it to int_coor_z


			LDA	original_point_y
			SUB	int_coor_y
			MUL	screen_cols
			ADD	original_point_x
			ADD	int_coor_x	... position = (22-y)*100 + 50-(-x);

			... Continue here (3/10) ...
			STA	position
			LDX	position
			LDT	#6
			MULR	T, X		... multiply 6 because f_check_front_pos's type is float
			LDF	f_check_front_pos, X
			COMPF	#0		... if (check_front_symbols[position]==0)
			JEQ	equal_zero_or_greater_z
			COMPF	f_coor_z	... else (check_front_symbols[position] > z)
			JGT	equal_zero_or_greater_z
			J	calculate_cube_surface_return
			. J	ccc	... only for test
equal_zero_or_greater_z	LDF	f_coor_z
			. LDT	#6
			. MULR	T, X
			STF	f_check_front_pos, X
			. SUBR	T, X
			. DIVR	B, X		... divide 6 because colors matrix is type byte
			. LDX	#0
			. DIVR	T, X
ccc			LDX	position
			LDCH	cur_color
			STCH	colors, X	... write color to colors matrix
			. J	calculate_cube_surface_return
calculate_cube_surface_return
			LDL	temp_L_2
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
			STF	cos_f_angle_a	... store it to cos_f_angle_a

			LDF	f_angle_b
			STF	f_x
			JSUB	cos_func	... calc cos(f_angle_b),
			LDF	f_result
			STF	cos_f_angle_b	... store it to cos_f_angle_b

			LDF	f_angle_c
			STF	f_x
			JSUB	cos_func	... calc cos(f_angle_c),
			LDF	f_result
			STF	cos_f_angle_c	... store it to cos_f_angle_c

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
		LDF	f_temp
		SUBF	f_temp_2
		MULF	f_cube_y
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
		MULF	cos_f_angle_a
		MULF	cos_f_angle_b
		STF	f_term_3	... f_term_3 = cos(a)*cos(b)*z

		LDF	f_term_1
		ADDF	f_term_2
		ADDF	f_term_3
		STF	f_result	...
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
		MULF	f_sqare_x	... F = f_x ^ 5
		STF	f_temp		... f_temp = f_x ^ 5
		DIVF	#120
		STF	f_term_3	... f_term_3 = (f_x ^ 5) / (5!)
		LDF	f_temp
		MULF	f_sqare_x	... F = f_x ^ 7
		STF	f_temp
		+DIVF	#5040		... 5040 = 7!
		STF	f_term_4	... f_term_4 = (f_x ^ 7) / (7!)
		LDF	f_temp
		MULF	f_sqare_x
		STF	f_temp		... f_temp = f_x ^ 9
		+DIVF	#362880		... 362880 = 9!
		STF	f_term_5	... f_term_5 = (f_x ^ 9) / (9!)
		LDF	f_temp
		MULF	f_sqare_x
		STF	f_temp		... f_temp = f_x ^ 11
		+DIVF	#362880
		DIVF	#110		... 362880 * 110 = 11!
		STF	f_term_6	... f_term_6 = (f_x ^ 11) / (11!)
		LDF	f_temp
		MULF	f_sqare_x
		STF	f_temp		... f_temp = f_x ^ 13
		+DIVF	#362880
		DIVF	#110
		DIVF	#156		... 11! * 12 * 13 = 13!
		STF	f_term_7	... f_term_7 = (f_x ^ 13) / (13!)

		LDF	f_x
		SUBF	f_term_2
		ADDF	f_term_3
		SUBF	f_term_4
		ADDF	f_term_5
		SUBF	f_term_6
		ADDF	f_term_7
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
		STF	f_temp		... f_temp = f_x ^ 8
		DIVF	#720
		DIVF	#56		... 720 * 56 = 8!
		STF	f_term_5	... f_term_5 = (f_x ^ 8) / (8!)
		LDF	f_temp
		MULF	f_sqare_x
		STF	f_temp		... f_temp = f_x ^ 10
		+DIVF	#40320
		DIVF	#90		... 40320 * 90 = 10!
		STF	f_term_6	... f_term_6 = (f_x ^ 10) / (10!)
		LDF	f_temp
		MULF	f_sqare_x
		STF	f_temp		... f_temp = f_x ^ 12
		+DIVF	#40320
		DIVF	#90
		DIVF	#132		... 10! * 11 * 12 = 12!
		STF	f_term_7	... f_term_7 = (f_x ^ 12) / (12!)

		LDF	#1
		SUBF	f_term_2
		ADDF	f_term_3
		SUBF	f_term_4
		ADDF	f_term_5
		SUBF	f_term_6
		ADDF	f_term_7
		STF	f_result	... store the result to f_result
		RSUB




variable_init	CLEAR	A
		FLOAT
		... create a floating negative 1
		SUBF	#1
		STF	f_negative_one
		... create a pi
		LDF	#314
		DIVF	#100
		STF	pi
		.. set angle_* to negative pi
		. MULF	f_negative_one
		STF	f_angle_a
		STF	f_angle_b
		STF	f_angle_c


		... set rotate_speed to
		... 0.05, 0.05, 0.01
		... to f_rotate_speed_for_{x, y, z}
		LDF	#0
		LDF	#5
		DIVF	#100
		STF	f_rotate_speed_for_x
		STF	f_rotate_speed_for_y

		DIVF	#5
		STF	f_rotate_speed_for_z

		... set cube width to 20
		LDF	#28
		STF	f_cube_width
		DIVF	#2
		STF	f_half_cube_width

		... set original_point_{x, y} to half screen width and column
		LDA	screen_rows
		DIV	#2
		STA	original_point_y
		LDA	screen_cols
		DIV	#2
		STA	original_point_x

		... set loop condition
		LDF	f_cube_width
		DIVF	#2
		STF	f_outer_loop_condition

		LDF	f_cube_width
		DIVF	#2
		STF	f_inner_loop_condition
		RSUB


......
... Constants
......
screen_start	WORD	X'00A000'
screen_rows	WORD	64
screen_cols	WORD	64

... colors
... TODO: the name, change to: color_bg, color_f, etc.
. bg_color	BYTE	X'00'	... color black
bg_color	BYTE	0b00000000	... color black
f_color		BYTE	X'CC'	... color green
b_color		BYTE	X'D7'	... color blue
r_color		BYTE	X'F0'	... color red
l_color		BYTE	X'F8'	... color orange
u_color		BYTE	X'FF'	... color white
d_color		BYTE	X'FC'	... color yellow

int_negative_one	WORD	-1


......
... Variables
......
original_point_x	RESW	1
original_point_y	RESW	1

position		RESW	1

cur_color		RESB	1

size			EQU	4096
.. matrices for colors and front pos
colors			RESB	size
... the type is float
... WARNING: this matrix might need to add
... 6 when indexing
f_check_front_pos	RESF	size


temp_L		RESW	1
temp_L_2	RESW	1
temp_L_3	RESW	1
temp_L_4	RESW	1

... coordinate in matrix
int_coor_x	RESW	1
int_coor_y	RESW	1
int_coor_z	RESW	1

......
... float number part
......
f_cube_width		RESF	1
f_half_cube_width	RESF	1

pi		RESF	1

f_rotate_speed_for_x	RESF	1
f_rotate_speed_for_y	RESF	1
f_rotate_speed_for_z	RESF	1

fx		RESF	1
fy		RESF	1

... coordinate for calculating cube surface
f_cube_x	RESF	1
f_cube_y	RESF	1
f_cube_z	RESF	1

... coordinate after calculate cube surface
f_coor_x 	RESF	1
f_coor_y 	RESF	1
f_coor_z 	RESF	1

......
... angle
......
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
f_negative_one	RESF	1
f_x		RESF	1
f_sqare_x	RESF	1
f_term_1	RESF	1	... 
f_term_2	RESF	1	... 多項式第二項
f_term_3	RESF	1	... 多項式第三項
f_term_4	RESF	1	... 多項式第四項
f_term_5	RESF	1	... 多項式第五項
f_term_6	RESF	1	... 多項式第六項
f_term_7	RESF	1	... 多項式第七項
f_result	RESF	1

f_outer_loop_condition	RESF	1
f_inner_loop_condition	RESF	1

	END	rc
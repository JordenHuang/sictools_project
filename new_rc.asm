. at 3/19, TODO: sin, cos function, don't forget to check variables name, some of them might have changed
. at 3/24, add many subrutines, and make them more clear

.-- rc for rotated cube
rc			START	0
			JSUB	variable_init
			JSUB	memset_f_ch_fnt_z

	. JSUB	main

halt			J	halt

.==================================================

... f_check_front_z memset subrutine
memset_f_ch_fnt_z	LDX	#0
			LDT	#6
			LDA	#0
			+LDS	#SIZE
			LDF	#1
mfcfp_for		STF	f_check_front_z, X
			ADDR	T, X
			ADD	#1

			COMPR	A, S
			JLT	mfcfp_for
			RSUB

.-- subrutine for calculate cube surface
calculate_cube_surface	STL	temp_L_2
			JSUB	calculate_x	.-- it will read f_cube_{x, y, z}, and calc them
			LDF	f_result
			STF	f_cube_x_result	.-- calc f_cube_x_result's value
			FIX
			STA	i_cube_x_result	.-- store it to i_cube_x_result

			JSUB	calculate_y
			LDF	f_result
			STF	f_cube_y_result	.-- calc f_cube_y_result's value
			FIX
			STA	i_cube_y_result	.-- store it to i_cube_y_result

			JSUB	calculate_z
			LDF	f_result
			STF	f_cube_z_result	.-- calc f_cube_z_result's value
			FIX
			STA	i_cube_z_result	.-- store it to i_cube_z_result


			LDA	opy
			SUB	i_cube_y_result
			MUL	screen_cols
			ADD	opx
			ADD	i_cube_x_result	.-- index = (22-y)*100 + 50-(-x);

			.-- Continue here (3/10) .--
			STA	index
			LDX	index
			LDT	#6
			MULR	T, X		.-- multiply 6 because f_check_front_z's type is float
			LDF	f_check_front_z, X
			COMPF	#0		.-- if (check_front_symbols[position]==0)
			JEQ	equal_zero_or_greater_z
			COMPF	f_cube_z_result	.-- else (check_front_symbols[position] > z)
			JGT	equal_zero_or_greater_z
			J	calculate_cube_surface_return
			. J	ccc	.-- only for test
equal_zero_or_greater_z	LDF	f_cube_z_result
			. LDT	#6
			. MULR	T, X
			STF	f_check_front_z, X
			. SUBR	T, X
			. DIVR	B, X		.-- divide 6 because colors matrix is type byte
			. LDX	#0
			. DIVR	T, X
ccc			LDX	index
			LDCH	cur_color
			STCH	colors, X	.-- write color to colors matrix
			. J	calculate_cube_surface_return
calculate_cube_surface_return
			LDL	temp_L_2
			RSUB

.==================== TODO: make comment more clear on the above lines ============

.-- subrutine for calculate sins and coss to f_angle_{a, b, c}
calculate_sins_and_coss	STL	temp_L		.-- store L to temp_L
			.-- sins
			LDF	f_angle_a
			STF	f_tri
			JSUB	sin_func	.-- calc sin(f_angle_a),
			LDF	f_result
			STF	sin_f_angle_a	.-- store it to sin_f_angle_a

			LDF	f_angle_b
			STF	f_tri
			JSUB	sin_func	.-- calc sin(f_angle_b),
			LDF	f_result
			STF	sin_f_angle_b	.-- store it to sin_f_angle_b

			LDF	f_angle_c
			STF	f_tri
			JSUB	sin_func	.-- calc sin(f_angle_c),
			LDF	f_result
			STF	sin_f_angle_c	.-- store it to sin_f_angle_c

			.-- coss
			LDF	f_angle_a
			STF	f_tri
			JSUB	cos_func	.-- calc cos(f_angle_a),
			LDF	f_result
			STF	cos_f_angle_a	.-- store it to cos_f_angle_a

			LDF	f_angle_b
			STF	f_tri
			JSUB	cos_func	.-- calc cos(f_angle_b),
			LDF	f_result
			STF	cos_f_angle_b	.-- store it to cos_f_angle_b

			LDF	f_angle_c
			STF	f_tri
			JSUB	cos_func	.-- calc cos(f_angle_c),
			LDF	f_result
			STF	cos_f_angle_c	.-- store it to cos_f_angle_c

			LDL	temp_L		.-- put temp_L to register L
			RSUB

calculate_x		LDF	f_cube_x
			MULF	cos_f_angle_b
			MULF	cos_f_angle_c
			STF	f_term_1	.-- f_term_1 = x*cos(b)*cos(c)
			LDF	f_cube_y
			MULF	cos_f_angle_b
			MULF	sin_f_angle_c
			STF	f_term_2	.-- f_term_2 = y*cos(b)*sin(c)
			LDF	f_cube_z
			MULF	sin_f_angle_b
			STF	f_term_3	.-- f_term_3 = z*sin(b)

			LDF	f_term_1
			SUBF	f_term_2
			ADDF	f_term_3
			STF	f_result
			RSUB

calculate_y		LDF	sin_f_angle_a
			MULF	sin_f_angle_b
			MULF	cos_f_angle_c
			STF	f_temp		.-- f_temp = sin(a)*sin(b)*cos(c)
			LDF	cos_f_angle_a
			MULF	sin_f_angle_c	.-- F = cos(a)*sin(c)
			ADDF	f_temp		.-- F = F + f_temp
			MULF	f_cube_x	
			STF	f_term_1	.-- f_term_1 = x*(sin(a)*sin(b)*cos(c) + cos(a)*sin(c))
			LDF	cos_f_angle_a
			MULF	cos_f_angle_c
			STF	f_temp		.-- f_temp = cos(a)*cos(c)
			LDF	sin_f_angle_a
			MULF	sin_f_angle_b
			MULF	sin_f_angle_c
			STF	f_temp_2	.-- f_temp_2 = sin(a)*sin(b)*sin(c)
			LDF	f_temp
			SUBF	f_temp_2
			MULF	f_cube_y
			STF	f_term_2	.-- f_term_2 = y*(cos(a)*cos(c)- sin(a)*sin(b)*sin(c))
			LDF	f_cube_z
			MULF	sin_f_angle_a
			MULF	cos_f_angle_b
			STF	f_term_3	.-- f_term_3 = z*sin(a)*cos(b)

			LDF	f_term_1
			ADDF	f_term_2
			SUBF	f_term_3
			STF	f_result	.--
			RSUB

calculate_z		LDF	sin_f_angle_a
			MULF	sin_f_angle_c
			STF	f_temp		.-- f_temp = sin(a)*sin(c)
			LDF	cos_f_angle_a
			MULF	sin_f_angle_b
			MULF	cos_f_angle_c
			STF	f_temp_2	.-- f_temp_2 = cos(a)*sin(b)*cos(c)
			LDF	f_temp
			SUBF	f_temp_2
			MULF	f_cube_x
			STF	f_term_1	.-- f_term_1 = (sin(a)*sin(c) - cos(a)*sin(b)*cos(c))*x
			LDF	cos_f_angle_a
			MULF	sin_f_angle_b
			MULF	sin_f_angle_c
			STF	f_temp		.-- f_temp = cos(a)*sin(b)*sin(c)
			LDF	sin_f_angle_a
			MULF	cos_f_angle_c	.-- F = sin(a)*cos(c)
			ADDF	f_temp		.-- F = F + f_temp
			MULF	f_cube_y	.-- F = (F + f_temp) * y
			STF	f_term_2	.-- f_term_2 = F
			LDF	f_cube_z
			MULF	cos_f_angle_a
			MULF	cos_f_angle_b
			STF	f_term_3	.-- f_term_3 = cos(a)*cos(b)*z

			LDF	f_term_1
			ADDF	f_term_2
			ADDF	f_term_3
			STF	f_result	.--
			RSUB

sin_func		LDF	f_tri
			MULF	f_tri		.-- F = f_tri ^ 2
			STF	f_sqare_x	.-- f_sqare_x = f_tri ^ 2
			LDF	f_tri
			MULF	f_sqare_x	.-- F = f_tri ^ 3
			STF	f_temp		.-- f_temp = f_tri ^ 3
			DIVF	#6		.-- 3! = 6
			STF	f_term_2	.-- f_term_2 = (f_tri ^ 3) / (3!)
			LDF	f_temp
			MULF	f_sqare_x	.-- F = f_tri ^ 5
			STF	f_temp		.-- f_temp = f_tri ^ 5
			DIVF	#120		.-- 5! = 120
			STF	f_term_3	.-- f_term_3 = (f_tri ^ 5) / (5!)
			LDF	f_temp
			MULF	f_sqare_x	.-- F = f_tri ^ 7
			STF	f_temp
			+DIVF	#5040		.-- 5040 = 7!
			STF	f_term_4	.-- f_term_4 = (f_tri ^ 7) / (7!)
			LDF	f_temp
			MULF	f_sqare_x
			STF	f_temp		.-- f_temp = f_tri ^ 9
			+DIVF	#362880		.-- 362880 = 9!
			STF	f_term_5	.-- f_term_5 = (f_tri ^ 9) / (9!)
			LDF	f_temp
			MULF	f_sqare_x
			STF	f_temp		.-- f_temp = f_tri ^ 11
			+DIVF	#362880
			DIVF	#110		.-- 362880 * 110 = 11!
			STF	f_term_6	.-- f_term_6 = (f_tri ^ 11) / (11!)
			LDF	f_temp
			MULF	f_sqare_x
			STF	f_temp		.-- f_temp = f_tri ^ 13
			+DIVF	#362880
			DIVF	#110
			DIVF	#156		.-- 11! * 12 * 13 = 13!
			STF	f_term_7	.-- f_term_7 = (f_tri ^ 13) / (13!)

			LDF	f_tri
			SUBF	f_term_2
			ADDF	f_term_3
			SUBF	f_term_4
			ADDF	f_term_5
			SUBF	f_term_6
			ADDF	f_term_7
			STF	f_result	.-- store the result to f_result
			RSUB	

cos_func		LDF	f_tri
			MULF	f_tri		.-- F = f_tri ^ 2
			STF	f_sqare_x	.-- f_sqare_x = f_tri ^ 2
			DIVF	#2
			STF	f_term_2	.-- f_term_2 = (f_tri ^ 2) / (2!)
			LDF	f_sqare_x
			MULF	f_sqare_x	.-- F = f_^ 4
			STF	f_temp		.-- f_temp = f ^ 4
			DIVF	#24		.-- 4!
			STF	f_term_3	.-- f_term_3 = (f_tri ^ 4) / (4!)
			LDF	f_temp
			MULF	f_sqare_x	.-- F = f_tri ^ 6
			STF	f_temp		.-- f_temp = f ^ 6
			DIVF	#720		.-- 6!
			STF	f_term_4	.-- f_term_4 = (f_tri ^ 6) / (6!)
			LDF	f_temp
			MULF	f_sqare_x	.-- F = f_tri ^ 8
			STF	f_temp		.-- f_temp = f_tri ^ 8
			DIVF	#720
			DIVF	#56		.-- 720 * 56 = 8!
			STF	f_term_5	.-- f_term_5 = (f_tri ^ 8) / (8!)
			LDF	f_temp
			MULF	f_sqare_x
			STF	f_temp		.-- f_temp = f_tri ^ 10
			+DIVF	#40320
			DIVF	#90		.-- 40320 * 90 = 10!
			STF	f_term_6	.-- f_term_6 = (f_tri ^ 10) / (10!)
			LDF	f_temp
			MULF	f_sqare_x
			STF	f_temp		.-- f_temp = f_tri ^ 12
			+DIVF	#40320
			DIVF	#90
			DIVF	#132		.-- 10! * 11 * 12 = 12!
			STF	f_term_7	.-- f_term_7 = (f_tri ^ 12) / (12!)

			LDF	#1
			SUBF	f_term_2
			ADDF	f_term_3
			SUBF	f_term_4
			ADDF	f_term_5
			SUBF	f_term_6
			ADDF	f_term_7
			STF	f_result	.-- store the result to f_result
			RSUB


variable_init		CLEAR	A
			.-- Create constants
			FLOAT
			.-- create a floating negative 1
			SUBF	#1
			STF	f_neg_one
			.-- create a pi
			LDF	#314
			DIVF	#100
			STF	pi

			.-- set angle_* to negative pi
			.-- FIXME: start with negative pi or positive pi?
			. MULF	f_negative_one
			STF	f_angle_a
			STF	f_angle_b
			STF	f_angle_c

			.-- Initialize variables
			.-- set rotate_speed to
			.-- 0.05, 0.05, 0.01
			.-- to f_rotate_speed_for_{x, y, z}
			LDF	#0
			LDF	#5
			DIVF	#100
			STF	f_rotate_speed_for_x
			STF	f_rotate_speed_for_y

			DIVF	#5
			STF	f_rotate_speed_for_z

			.-- set cube width to custom value
			LDF	#CUBE_WIDTH
			DIVF	#2
			STF	f_half_cube_width

			.-- set op{x, y} to half screen width and column
			LDA	screen_rows
			DIV	#2
			STA	opy
			LDA	screen_cols
			DIV	#2
			STA	opx

			.-- set loop condition
			LDF	#CUBE_WIDTH
			DIVF	#2
			STF	f_outer_loop_condition

			LDF	#CUBE_WIDTH
			DIVF	#2
			STF	f_inner_loop_condition
			RSUB


.===================================================
.===== Program parameters =====
.===== customizable values =====
screen_start		WORD	X'00A000'

.-- It's better to let the rows and cols the same value
screen_rows		WORD	64
screen_cols		WORD	64

.-- set SIZE to the result of screen_rows * screen_cols
SIZE			EQU	4096

CUBE_WIDTH		EQU	24

.-- colors (0biirrggbb, or 0x..)
color_bg		BYTE	0x00	.-- black
color_f			BYTE	0xCC	.-- green
color_b			BYTE	0xD7	.-- blue
color_r			BYTE	0xF0	.-- red
color_l			BYTE	0xF8	.-- orange
color_u			BYTE	0xFF	.-- white
color_d			BYTE	0xFC	.-- yellow

.===================================================
.===== Constants =====
.-- negative one in integer and float
i_neg_one		WORD	-1
f_neg_one		RESF	1

.-- pi is type float
pi			RESF	1

.-- original point x and y
.-- o(x, y) is the center of the graphical screen
opx			RESW	1
opy			RESW	1


.===================================================
.===== Variables =====
.-- index of the array (matrix)
index			RESW	1

.-- variable that stores the current color to print
cur_color		RESB	1

.-- array (matrices) that stores values of colors and z positions
colors			RESB	SIZE
.-- type float
f_check_front_z		RESF	SIZE

.-- Temporary variables
.-- temp_Ls store the link info of the last subrutine
temp_L			RESW	1
temp_L_2		RESW	1
temp_L_3		RESW	1
temp_L_4		RESW	1

.-- variables that stores the coordinate
.-- of the surface after rotation, in type integer
.-- (the integer type of f_cube_{x,y,z}_result)
i_cube_x_result		RESW	1
i_cube_y_result		RESW	1
i_cube_z_result		RESW	1

.-- Float number variables
f_half_cube_width	RESF	1


.-- coordinate for calculating cube surface
f_cube_x		RESF	1
f_cube_y		RESF	1
f_cube_z		RESF	1
.-- coordinate after calculating cube surface
f_cube_x_result		RESW	1
f_cube_y_result		RESW	1
f_cube_z_result		RESW	1

.-- Angle
.-- current rotation angle
f_angle_a		RESF	1
f_angle_b		RESF	1
f_angle_c		RESF	1

f_rotate_speed_for_x	RESF	1
f_rotate_speed_for_y	RESF	1
f_rotate_speed_for_z	RESF	1

.-- use for pre-calculation
.-- the result of sin( f_angle_{a, b, c} )
sin_f_angle_a		RESF	1
sin_f_angle_b		RESF	1
sin_f_angle_c		RESF	1
.-- the result of cos( f_angle_{a, b, c} )
cos_f_angle_a		RESF	1
cos_f_angle_b		RESF	1
cos_f_angle_c		RESF	1

.-- f_tri used only in sin and cos calculation
f_tri			RESF	1
.-- Variables for calculation
f_temp			RESF	1
f_temp_2		RESF	1
f_sqare_x		RESF	1
f_term_1		RESF	1	.-- 
f_term_2		RESF	1	.-- 多項式第二項
f_term_3		RESF	1	.-- 多項式第三項
f_term_4		RESF	1	.-- 多項式第四項
f_term_5		RESF	1	.-- 多項式第五項
f_term_6		RESF	1	.-- 多項式第六項
f_term_7		RESF	1	.-- 多項式第七項
f_result		RESF	1

.-- fx and fy is used as loop variables
fx			RESF	1
fy			RESF	1
f_outer_loop_condition	RESF	1
f_inner_loop_condition	RESF	1


			END	rc
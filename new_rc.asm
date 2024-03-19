. at 3/19, TODO: sin, cos function, don't forget to check variables name, some of them might have changed
... rc for rotated cube
rc	START	0
	JSUB	variable_init

	. JSUB	main

halt	J	halt

variable_init		CLEAR	A
			... Create constants
			FLOAT
			... create a floating negative 1
			SUBF	#1
			STF	f_neg_one
			... create a pi
			LDF	#314
			DIVF	#100
			STF	pi

			.. set angle_* to negative pi
			. MULF	f_negative_one
			STF	f_angle_a
			STF	f_angle_b
			STF	f_angle_c


			... Initialize variables
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

			... set cube width to custom value
			LDF	#CUBE_WIDTH
			DIVF	#2
			STF	f_half_cube_width

			... set op{x, y} to half screen width and column
			LDA	screen_rows
			DIV	#2
			STA	opy
			LDA	screen_cols
			DIV	#2
			STA	opx

			... set loop condition
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

. It's better to let the rows and cols the same value
screen_rows		WORD	64
screen_cols		WORD	64

. set SIZE to the result of screen_rows * screen_cols
SIZE			EQU	4096

CUBE_WIDTH		EQU	24

... colors (0biirrggbb, or 0x..)
color_bg		BYTE	0x00	. black
color_f			BYTE	0xCC	. green
color_b			BYTE	0xD7	. blue
color_r			BYTE	0xF0	. red
color_l			BYTE	0xF8	. orange
color_u			BYTE	0xFF	. white
color_d			BYTE	0xFC	. yellow

.===================================================
.===== Constants =====
. negative one in integer and float
i_neg_one		WORD	-1
f_neg_one		RESF	1

. pi is type float
pi			RESF	1

. original point x and y
. o(x, y) is the center of the graphical screen
opx			RESW	1
opy			RESW	1


.===================================================
.===== Variables =====
. index of the array (matrix)
index			RESW	1

. variable that stores the current color to print
cur_color		RESB	1

. array (matrices) that stores values of colors and z positions
colors			RESB	SIZE
. type float
f_check_front_z		RESF	SIZE

... Temporary variables
. temp_Ls store the link info of the last subrutine
temp_L			RESW	1
temp_L_2		RESW	1
temp_L_3		RESW	1
temp_L_4		RESW	1

. variables that stores the coordinate
. of the surface after rotation, in type integer
. (the integer type of f_cube_{x,y,z}_result)
i_cube_x_result		RESW	1
i_cube_y_result		RESW	1
i_cube_z_result		RESW	1

... Float number variables
f_half_cube_width	RESF	1


. coordinate for calculating cube surface
f_cube_x		RESF	1
f_cube_y		RESF	1
f_cube_z		RESF	1
. coordinate after calculating cube surface
f_cube_x_result		RESW	1
f_cube_y_result		RESW	1
f_cube_z_result		RESW	1

... Angle
. current rotation angle
f_angle_a		RESF	1
f_angle_b		RESF	1
f_angle_c		RESF	1

f_rotate_speed_for_x	RESF	1
f_rotate_speed_for_y	RESF	1
f_rotate_speed_for_z	RESF	1

. use for pre-calculation
. the result of sin( f_angle_{a, b, c} )
sin_f_angle_a		RESF	1
sin_f_angle_b		RESF	1
sin_f_angle_c		RESF	1
. the result of cos( f_angle_{a, b, c} )
cos_f_angle_a		RESF	1
cos_f_angle_b		RESF	1
cos_f_angle_c		RESF	1

. f_tri used only in sin and cos calculation
f_tri			RESF	1
... Variables for calculation
f_temp			RESF	1
f_temp_2		RESF	1
f_sqare_x		RESF	1
f_term_1		RESF	1	... 
f_term_2		RESF	1	... 多項式第二項
f_term_3		RESF	1	... 多項式第三項
f_term_4		RESF	1	... 多項式第四項
f_term_5		RESF	1	... 多項式第五項
f_term_6		RESF	1	... 多項式第六項
f_term_7		RESF	1	... 多項式第七項
f_result		RESF	1

. fx and fy is used as loop variables
fx			RESF	1
fy			RESF	1
f_outer_loop_condition	RESF	1
f_inner_loop_condition	RESF	1


	END	rc
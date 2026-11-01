;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Silke Behn
;* Version            : V1.0
;* Date               : 01.06.2021
;* Description        : This is a simple main.
;					  :
;					  : Replace this main with yours.
;
;*******************************************************************************
    EXTERN initITSboard
    EXTERN lcdPrintS            ;Display ausgabe
    EXTERN GUI_init
;	EXTERN TP_Init

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************

	AREA MyData, DATA, align = 2

	    GLOBAL text
DEFAULT_BRIGHTNESS DCW  800

text	DCB	"Hallo liebes TI-Labor (asm-project)",0

;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

;--------------------------------------------
; main subroutine
;--------------------------------------------
	EXPORT main [CODE]
;                                                     |     Memory addresses     |
;                                                     | 00 01 02 03 04 05 06 07  |
;                                                     | 08 09 0A 0B 0C 0D 0E 0F  |
;                                                     | 10 11 12 13 14 15 16 17  |
;                                                     | 18 19 1A 1B 1C 1D 1E 1F  |
;                                                     | .. .. .. .. .. .. .. ..  |
;                                                     | F8 F9 FA FB FC FD FE FF  |

;      ASM Line      ;   Size      ; Address          | Memory representation(LE)|
Dword1    DCD 0x12   ; four bytes  ;   0x100 to 0x103 | 12 00 00 00 .. .. .. ..  |
Halfword1 DCW 0x45   ; two bytes   ;   0x104 to 0x105 | .. .. .. .. 45 00 .. ..  |
Halfword2 DCW 0x1188 ; two bytes   ;   0x106 to 0x107 | .. .. .. .. .. .. 88 11  |
;                    ; eight bytes ;                  +--------------------------+
byte1     DCB 0x33   ; one byte    ;   0x108          | 33 .. .. .. .. .. .. ..  |
Halfword3 DCW 0x7777 ; two bytes   ;   0x10A to 0x10B | .. -- 77 77 .. .. .. ..  |
byte2     DCB 0x44   ; one byte    ;   0x11C          | .. -- .. .. 44 .. .. ..  |
;                    ; 4B>4B unfilled due next to DCD +--------------------------+
;  Intermediate rep  ; four bytes  ;   0x110 to 0x117 | 33 -- 77 77 44 -- -- --  |
;                    ; eight bytes ;                  +--------------------------+
Dword2    DCD 0x8888 ; four bytes  ;   0x118 to 0x11B | 88 88 00 00 .. .. .. ..  |


main	PROC
        BL initITSboard
		ldr r1, =DEFAULT_BRIGHTNESS
		ldrh r0, [r1]
		bl GUI_init
		mov r0, #0x00
;		bl TP_Init


		LDR	r0,=text
        BL  lcdPrintS

forever	b	forever		; nowhere to retun if main ends
		ENDP

		ALIGN

		END

;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Martin Becke
;* Version            : V1.0
;* Date               : 01.06.2021
;* Description        : This is a simple main to demonstrate data transfer
;                     : and manipulation.
;                     :
;
;*******************************************************************************
    EXTERN initITSboard ; Helper to organize the setup of the board

    EXPORT main         ; we need this for the linker - In this context it set the entry point,too

ConstByteA  EQU 0xaffe

;* We need some data to work on
    AREA DATA, DATA, align=2
VariableA   DCW 0xbeef ; loaded as EF BE in memory (LE)
VariableB   DCW 0x1234
VariableC   DCW 0x0000 ; Für affe var.

;* We need minimal memory setup of InRootSection placed in Code Section
    AREA  |.text|, CODE, READONLY, ALIGN = 3
    ALIGN
main
    BL initITSboard             ; needed by the board to setup
;* swap memory - Is there another, at least optimized approach?
;* Yes: ldrh R2, [R0] / rev16 R2, R2 / strh R2, [R0]  (3 instructions instead of 5)
    ldr     R0,=VariableA   ; Anw01
    ldrb    R2,[R0]         ; Anw02 load register byte. Loads 8 bit unsigned byte from memory address in R0 to register R2.
    ldrb    R3,[R0,#1]      ; Anw03 load with immediate offset of 1 into R3.
    lsl     R2, #8          ; Anw04 logical shift left. shift r2 by 8 bits, store in R2.
    orr     R2, R3          ; Anw05 bitwise or between R2 and R3 store back in R2.
    strh    R2,[R0]         ; Anw06 store half word. Stores 16 bit halfword from R2 to the memory address in R0.
; We swap the first and second bytes of the half word. 0xefbe becomes 0xbeef in memory.
;* const in var - Same function as in
    ;mov     R5,#ConstByteA  ; Anw07 loads immediate value into register R5.
    ;strh    R5,[R0]         ; Anw08 stores halfword of R5 into the memory address pointed to by R0.
;* const in var - Same function as for "beef" Dest is VariableC.
    ldr     R4,=VariableC   ; Adress of VariableC
    mov     R5,#ConstByteA  ; Anw07  R5 = 0xAFFE
    strb    R5,[R4,#1]      ; Anw08a Store lower byte 0xFE (to higher address)
    lsr     R5, #8          ; Anw08b R5 = 0x00AF (logical shift right)
    strb    R5,[R4]         ; Anw08c Store higher Byte 0xAF (to lower Address)

;* Change value so that memory shows 12 34
    ldr     R1,=VariableB   ; Anw09
    ldrh    R6,[R1]         ; Anw0A R6 = 0x1234
    mov     R7, #0x21DE     ; Anw0B 0x3412 - 0x1234 = 0x21DE
    add     R6, R6, R7      ; Anw0C R6 = 0x3412
    strh    R6,[R1]         ; Anw0D 12 34 :)
    b .                     ; Anw0E

    ALIGN
    END

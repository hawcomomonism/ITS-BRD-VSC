;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Martin Becke
;* Version            : V1.0
;* Date               : 01.06.2021
;* Description        : This is a simple main to demonstrate data transfer
;                     : and manipulation
;*******************************************************************************
    EXTERN initITSboard
    EXPORT main
    ; consts
    AREA DATA, DATA, align=2
    ; vars
    Var1 DCB 0x33
    Var2 DCB 0xAB
    Res  DCW 0
    AREA  |.text|, CODE, READONLY, ALIGN = 3
    ALIGN
main
    BL initITSboard
    ; instr

    ldr  R0, =Var1
    ldrb R1,[R0]
    ldr  R2, =Var2
    ldrb R3,[R2]
    add  R4,R1,R3
    add R4,R4,#1
    strh R4,[Res]

    b .
    ALIGN
    END

;************************************************
;* Beginn der globalen Daten *
;************************************************
                   AREA MyData, DATA, align = 2
Base
VariableA          DCW 0x1234
VariableB          DCW 0x4711

VariableC          DCD  0

MeinHalbwortFeld   DCW 0x22 , 0x3e , -52, 78 , 0x27 , 0x45

MeinWortFeld       DCD 0x12345678 , 0x9dca5986
                   DCD -872415232 , 1308622848
                   DCD 0x27000000
                   DCD 0x45000000

MeinTextFeld       DCB "ABab0123",0

                   EXPORT VariableA
                   EXPORT VariableB
                   EXPORT VariableC
                   EXPORT MeinHalbwortFeld
                   EXPORT MeinWortFeld
                   EXPORT MeinTextFeld

;***********************************************
;* Beginn des Programms *
;************************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3
; ----- S t a r t des Hauptprogramms -----
                EXPORT main
                EXTERN initITSboard
main            PROC
                bl    initITSboard                 ; HW Initialisieren

; Laden von Konstanten in Register
                mov   r0,#0x12                      ; Anw-01
                mov   r1,#-128                      ; Anw-02
                ldr   r2,=0x12345678                ; Anw-03

; Zugriff auf Variable
                ldr   r0,=VariableA                 ; Anw-04
                ldrh  r1,[r0]                       ; Anw-05
                ldr   r2,[r0]                       ; Anw-06
                str   r2,[r0,#VariableC-VariableA]  ; Anw-07

; Zugriff auf Felder (Speicherzellen)
                ldr   r0,=MeinHalbwortFeld          ; Anw-08
                ldrh  r1,[r0]                       ; Anw-09
                ldrh  r2,[r0,#2]                    ; Anw-10
                mov   r3,#10                        ; Anw-11
                ldrh  r4,[r0,r3]                    ; Anw-12

                ldrh  r5,[r0,#2]!                   ; Anw-13
                ldrh  r6,[r0,#2]!                   ; Anw-14
                strh  r6,[r0,#2]!                   ; Anw-15

; Addition und Subtraktion von unsigned / signed Integer-Werten
                ldr  r0,=MeinWortFeld               ; Anw-16
                ldr  r1,[r0]                        ; Anw-17
                ldr  r2,[r0,#4]                     ; Anw-18
                adds r3,r1,r2                       ; Anw-19

                ldr  r4,[r0,#8]                     ; Anw-20
                ldr  r5,[r0,#12]                    ; Anw-21
                subs r6,r4,r5                       ; Anw-22

                ldr  r7,[r0,#16]                    ; Anw-23
                ldr  r8,[r0,#20]                    ; Anw-24
                subs r9,r7,r8                       ; Anw-25

forever         b   forever                         ; Anw-26
                ENDP
                END

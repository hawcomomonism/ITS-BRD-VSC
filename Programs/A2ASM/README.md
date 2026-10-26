# Aufgabe A2: Byte Reihenfolge (LE)

Der Prozessor arbeitet mit Little Endian Format (also kleinste Byte liegt auf kleinerer Adresse).
Die Variable `VariableA DCW 0xbeef` steht daher zu Beginn als Bytes `EF BE` im Speicher, obwohl im Code "beef" steht.


## Anw01 bis Anw06 (Byte Swap von VariableA)

| Zeile | Befehl | R0 | R2 | R3 | Speicher ab 0x2000000c (0x2000000c, 0x2000000c+1) |
|---|---|---|---|---|---|
| Start | - | ? | ? | ? | `EF BE` |
| Anw01 | `ldr R0, =VariableA` | 0x2000000c | - | - | `EF BE` |
| Anw02 | `ldrb R2, [R0]` | 0x2000000c | 0x000000EF | - | `EF BE` |
| Anw03 | `ldrb R3, [R0,#1]` | 0x2000000c | 0x000000EF | 0x000000BE | `EF BE` |
| Anw04 | `lsl R2, #8` | 0x2000000c | 0x0000EF00 | 0x000000BE | `EF BE` |
| Anw05 | `orr R2, R3` | 0x2000000c | 0x0000EFBE | 0x000000BE | `EF BE` |
| Anw06 | `strh R2, [R0]` | 0x2000000c | 0x0000EFBE | 0x000000BE | `BE EF` |

Erläuterung:
- Anw01 lädt die Adresse von `VariableA` in Register R0.
- Anw02/03 laden die beiden Bytes einzeln (Rest mit Nullen befüllt).
  Erst das Byte auf 0x2000000c (0xEF) in R2, dann das Byte auf 0x2000000c+1 (0xBE) in R3.
- Anw04 schiebt R2 um 8 Bit nach links. 0xEF steht jetzt im höheren Byte.
- Anw05: Über die `oder` Anweisung wird R3 in das freie niederwertige Byte "geschoben", R2 = 0xEFBE.
- Anw06 schreibt R2 als Halbwort zurück. Little Endian legt das niederwertige
  Byte 0xBE auf 0x2000000c und 0xEF auf 0x2000000c+1. Im Speicher steht nun `BE EF`, also lesbar "beef".

Einfachere Alternative (3 Befehle): `ldrh R2, [R0]`, `rev16 R2, R2`, `strh R2, [R0]`.
`rev16` wechselt die Byte Reihenfolge des Halbworts.

## Anw07/Anw08 ("affe" in VariableC)

Wir fügen oben in `AREA DATA` die Zeile: `VariableC DCW 0x0000` hinzu.
Die Konstante 0xAFFE wird so abgelegt, dass im Speicher `AF FE` steht:

| Zeile | Befehl | Effekt |
|---|---|---|
| - | `ldr R4, =VariableC` | R4 = Adresse der VariableC |
| Anw07 | `mov R5, #ConstByteA` | R5 = 0xAFFE |
| Anw08a | `strb R5, [R4,#1]` | niederwertiges Byte 0xFE auf die höhere Adresse |
| Anw08b | `lsr R5, #8` | R5 = 0x00AF |
| Anw08c | `strb R5, [R4]` | 0xAF auf die niedrigere Adresse |

Das Ergebnis im Speicher ist am Ende `AF FE`.

## Anw09 bis Anw0D (VariableB: Speicher soll `12 34` zeigen)

Der Ausgangswert `0x1234` liegt als `34 12` im Speicher. Damit `12 34` im Speicher
steht, muss das Halbwort `0x3412` sein. Dafür ändern wir die Zeile Anw0B von `mov R7, #0x30ED` zu `mov R7, #0x21DE` (da `0x3412 - 0x1234 = #0x21DE`).

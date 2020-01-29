;
; Zeitschleife.asm
;
; Created: 29.01.2020 10:20:34
; Author : rene
;


.def temp = r16
.def eingabereg = r17
.def ausgabereg = r18
.def zaehlreg1 = r19
.def zaehlreg2 = r20

init:
	//PortD als Eingabe mit pullup-R und PortA als Ausgabe
	ldi temp, 0xFF
	out PORTD, temp
	out DDRA, temp
	ldi temp, 0
	out DDRD, temp

endlos:
	//Warten bis Taster gedrückt wird(Low an PD0)
	warten_auf_taste_druecken:
		in eingabereg, PIND
		andi eingabereg, 0b00000001
		brbc SREG_Z, warten_auf_taste_druecken

		//Kontaktprellen abwarte, ca. 10ms
		ldi zaehlreg2, 13
		aussen1:
			ldi zaehlreg1, 0xFF
			innen1:
				dec zaehlreg1
				brbc SREG_Z, innen1
				dec zaehlreg2
				brbc SREG_Z, aussen1

		//Zustand PA7 (LED) lesen, PA7 inventieren und ausgeben an PortA
		in ausgabereg, PINA
		ldi temp, 0b10000000
		eor ausgabereg, temp
		out PORTA, ausgabereg

	//Warten bis Taster losgelassen wird(High an PD0)
	warten_auf_taste_loslassen:
		in eingabereg, PIND
		andi eingabereg, 0b00000001
		brbs SREG_Z, warten_auf_taste_loslassen

		//Kontaktprellen abwarte, ca. 10ms
		ldi zaehlreg2, 13
		aussen2:
			ldi zaehlreg1, 0xFF
			innen2:
				dec zaehlreg1
				brbc SREG_Z, innen2
				dec zaehlreg2
				brbc SREG_Z, aussen2

jmp endlos

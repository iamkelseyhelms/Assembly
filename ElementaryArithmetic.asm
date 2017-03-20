TITLE Elementary Arithmetic     (Program01.asm)

; Author: Kelsey Helms
; E-Mail: helmsk@oregonstate.edu
; Course: CS271-400
; Project ID: Program01
; Due date: July 3, 2016                 
; Description: This program will introduce the programmer, get two numbers from the user, and produce the sum, difference, product, quotient, and remainder.

INCLUDE Irvine32.inc

.data

;----------------------------------------------------------------------------------------------messages
intro			BYTE	"	Elementary Arithmetic		by Kelsey Helms", 0
intro2			BYTE	"**EC: Program repeats until user chooses to quit.", 0
intro3			BYTE	"**EC: Program verifies second number is less than first.", 0
intro4			BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
prompt1			BYTE	"First number: ", 0
prompt2			BYTE	"Second number: ", 0
remain			BYTE	" remainder ", 0
negative		BYTE	"The second number must be less than the first!", 0
repetition1		BYTE	"Press any key to quit program ", 0
goodbye			BYTE	"Impressed? Bye!", 0
;----------------------------------------------------------------------------------------------math
plus			BYTE	" + ", 0
subtract		BYTE	" - ", 0
times			BYTE	" x ", 0
divide			BYTE	" / ", 0
equals			BYTE	" = ", 0
;----------------------------------------------------------------------------------------------variables
number1			DWORD	?
number2			DWORD	?
sum			DWORD	?
difference		DWORD	?
product			DWORD	?
quotient		DWORD	?
remainder		DWORD	?
char			BYTE	?


.code

;-----------------------------------------------;
; PROC:		main				;
; PURPOSE:	runs program 			;
; PARAMETERS:	none				;
; RETURNS:	none				;
;-----------------------------------------------;

main PROC

;------------------------------------------------Introduce programmer
	mov	edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov	edx, OFFSET intro2
	call	WriteString
	call	CrLf
	mov	edx, OFFSET intro3
	call	WriteString
	call	CrLf
	call	CrLf
	mov	edx, OFFSET intro4
	call	WriteString

;------------------------------------------------Get numbers from user
Top :
	call	CrLf
	call	Crlf
	mov	edx, OFFSET prompt1
	call	WriteString
	call	ReadInt
	mov	number1, eax
	mov	edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov	number2, eax
	call	CrLf

;------------------------------------------------Test if number1 is greater than number2
	mov	eax, number1
	cmp	eax, number2
	jl	NegSubtraction

;------------------------------------------------Calculate results

;------------------------------------------------Add
	mov	eax, number1
	add	eax, number2
	mov	sum, eax

;------------------------------------------------Subtract
	mov	eax, number1
	sub	eax, number2
	mov	difference, eax

;------------------------------------------------Multiply
	mov	eax, number1
	mov	ebx, number2
	mul	ebx
	mov	product, eax

;------------------------------------------------Divide
	mov	edx, 0
	mov	eax, number1
	mov	ebx, number2
	div	ebx
	mov	quotient, eax
	mov	remainder, edx


;------------------------------------------------Display results

;------------------------------------------------Add
	mov	eax, number1
	call	WriteDec
	mov	edx, OFFSET plus
	call	WriteString
	mov	eax, number2
	call	WriteDec
	mov	edx, OFFSET equals
	call	WriteString
	mov	eax, sum
	call	WriteDec
	call	CrLf
;------------------------------------------------Subtract
	mov	eax, number1
	call	WriteDec
	mov	edx, OFFSET subtract
	call	WriteString
	mov	eax, number2
	call	WriteDec
	mov	edx, OFFSET equals
	call	WriteString
	mov	eax, difference
	call	WriteDec
	call	CrLf
;------------------------------------------------Multiply	
	mov	eax, number1
	call	WriteDec
	mov	edx, OFFSET times
	call	WriteString
	mov	eax, number2
	call	WriteDec
	mov	edx, OFFSET equals
	call	WriteString
	mov	eax, product
	call	WriteDec
	call	CrLf
;------------------------------------------------Divide	
	mov	eax, number1
	call	WriteDec
	mov	edx, OFFSET divide
	call	WriteString
	mov	eax, number2
	call	WriteDec
	mov	edx, OFFSET equals
	call	WriteString
	mov	eax, quotient
	call	WriteDec
	mov	edx, OFFSET remain
	call	WriteString
	mov	eax, remainder
	call	WriteDec
	call	CrLf
	call	CrLf
	jmp	GoToEnd

;------------------------------------------------Warn user number1 must be greater than number2
NegSubtraction :
	mov	edx, OFFSET negative
	call	WriteString
	call	CrLf
	call	CrLf

;------------------------------------------------Ask user if they want to repeat
GoToEnd :
	mov	edx, OFFSET repetition1
	call	WriteString
	mov	eax, 5000
	call	Delay
	call	ReadKey
	jz	Top
	mov	char, AL
	
;------------------------------------------------Say goodbye
	call	CrLf
	call	CrLf
	mov	edx, OFFSET goodbye
	call	WriteString
	call	CrLf

;------------------------------------------------exit to operating system
	exit
main ENDP

END main

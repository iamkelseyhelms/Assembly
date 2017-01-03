TITLE Fibonacci numbers     (Program02.asm)

; Author: Kelsey Helms
; E-Mail: helmsk@oregonstate.edu
; Course: CS271-400
; Project ID: Program01
; Due date: July 8, 2016                 
; Description: This program will introduce the programmer, get a number from the user, and produce that many terms of Fibonacci numbers.

INCLUDE Irvine32.inc



.data

intro			BYTE	"	Fibonacci Numbers		by Kelsey Helms", 0
EC				BYTE	"**EC: This program displays the numbers in aligned columns.",0
getName			BYTE	"What's your name? ",0
hello			BYTE	"Hello, ",0
intro2			BYTE	"Enter the number of Fibonacci terms to be displayed.",0
range			BYTE	"Give the number as an integer in the range [1 .. 46].",0
getNum			BYTE	"How many Fibonacci terms do you want? ",0
outOfRange		BYTE	"Out of range. Enter a number in [1 .. 46].",0
goodbye1		BYTE	"Results certified by Kelsey Helms.",0
goodbye2		BYTE	"Goodbye, ",0
userName		BYTE	33 DUP(0)
inputNum		DWORD	?
term1			DWORD	0
term2			DWORD	1
tempterm		DWORD	?
count			DWORD	4
count2			DWORD	36

.code
main PROC

;Introduce programmer
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	EC
	call	WriteString
	call	CrLf
	call	CrLf

;Get Name
	mov		edx, OFFSET getName		;prompt user to enter name
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString				;read in user's name to name
	mov		edx, OFFSET hello		;say hello to user
	call	WriteString
	mov		edx, OFFSET userName	;using user's name
	call	WriteString
	call	CrLf
	call	CrLf

;Introduce range
	mov		edx, OFFSET intro2		;introduce program concept
	call	WriteString
	call	CrLf
	mov		edx, OFFSET range		;introduce range
	call	WriteString
	call	CrLf
	call	CrLf

;Get number
	mov		edx, OFFSET getNum		;prompt user for number
	call	WriteString
	call	ReadInt					;read input into inputNum
	mov		inputNum, eax


;Check range
CheckRange :
	mov		eax, inputNum
	cmp		eax, 1					;check number against low end
	jl		OutsideRange				;jump to OutOfRange if too low
	cmp		eax, 46					;check number against high end
	jg		OutsideRange				;jump to OutOfRange if too high
	jmp		InRange					;skip OutOfRange if in range

;If the number is out of range, re-enter number
OutsideRange :
	mov	edx, OFFSET outOfRange		;warn user out of range
	call	WriteString
	call	CrLf
	mov		edx, OFFSET getNum		;prompt user for number
	call	WriteString
	call	ReadInt					;read input into inputNum
	mov		inputNum, eax
	jmp		CheckRange


;If number is in range, continue forward
InRange :

;Set up amount of loops
	mov		ecx, inputNum		;set user input as amount of times looped

Terms:
;Display number
	mov		eax, term2			;write out term2, which is either "1" the first time, or result any time after
	call	WriteDec

;Calculate next term
	mov		eax, term1			;calculate next term
	add		eax, term2
	mov		tempterm, eax		;move result into tempterm for safekeeping
	mov		eax, term2			;shift 2nd term to 1st term
	mov		term1, eax
	mov		eax, tempterm		;shift result to 2nd term
	mov		term2, eax
	mov     al,  TAB        ;horizontal tab
    call    WriteChar

;Because if more than 36 terms are displayed, tabs warp columns, see if there are more than 36 terms to be displayed.
;If so, add a second tab to first 36 terms, then only one tab after
	sub		count2, 1		;checking if reached 36
	cmp		count2, 0
	je		CheckTabs		;if so skip second tab
	mov     al,  TAB        ;horizontal tab
    call    WriteChar

CheckTabs :				
	cmp		count2, 0		;if reached 36 terms, keep count2 at zero to continue skipping second tab
	je		AddOne			
	jmp		CheckColumns	;if haven't reached 36 terms, skip addition to continue second tab

AddOne :
	add		count2, 1		;add one to count2 to keep at zero

CheckColumns :
	sub		count, 1		;if reached four terms, start new line
	cmp		count, 0
	jne		LoopAgain		;else, skip new line and display next term, start next calculation
	mov		count, 4		; if reached four terms, start count to four over again
	call	CrLf
LoopAgain :
	loop	Terms				;loop as many times as user wanted


;Say goodbye
	call	CrLf				
	call	CrLf
	mov		edx, OFFSET goodbye1		;verify results with programmer name
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodbye2		;say goodbye
	call	WriteString
	mov		edx, OFFSET userName		;with user's name
	call	WriteString
	call	CrLf
	call	CrLf

; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main

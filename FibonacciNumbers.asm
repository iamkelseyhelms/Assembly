TITLE Fibonacci numbers     (Program02.asm)

; Author: Kelsey Helms
; E-Mail: helmsk@oregonstate.edu
; Course: CS271-400
; Project ID: Program01
; Due date: July 8, 2016                 
; Description: This program will introduce the programmer, get a number from the user, and produce that many terms of Fibonacci numbers.

INCLUDE Irvine32.inc

.data

;----------------------------------------------------------------------------------------------messages
intro			BYTE	"	Fibonacci Numbers		by Kelsey Helms", 0
EC			BYTE	"**EC: This program displays the numbers in aligned columns.",0
getName			BYTE	"What's your name? ",0
hello			BYTE	"Hello, ",0
intro2			BYTE	"Enter the number of Fibonacci terms to be displayed.",0
range			BYTE	"Give the number as an integer in the range [1 .. 46].",0
getNum			BYTE	"How many Fibonacci terms do you want? ",0
outOfRange		BYTE	"Out of range. Enter a number in [1 .. 46].",0
goodbye1		BYTE	"Results certified by Kelsey Helms.",0
goodbye2		BYTE	"Goodbye, ",0
;----------------------------------------------------------------------------------------------variables
userName		BYTE	33 DUP(0)
inputNum		DWORD	?
term1			DWORD	0
term2			DWORD	1
tempterm		DWORD	?
count			DWORD	4
count2			DWORD	36

.code

;-----------------------------------------------;
; PROC:		main				;
; PURPOSE:	runs program 			;
; PARAMETERS:	none				;
; RETURNS:	none				;
;-----------------------------------------------;

main PROC

;----------------------------------------------------------------------------------------------introduce programmer
	mov	edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov	edx, OFFSET EC
	call	WriteString
	call	CrLf
	call	CrLf

;----------------------------------------------------------------------------------------------prompt user to enter name
	mov	edx, OFFSET getName
	call	WriteString
;----------------------------------------------------------------------------------------------read in user's name
	mov	edx, OFFSET userName
	mov	ecx, 32
	call	ReadString
;----------------------------------------------------------------------------------------------say hello to user using their name
	mov	edx, OFFSET hello
	call	WriteString
	mov	edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf

;----------------------------------------------------------------------------------------------introduce program concept
	mov	edx, OFFSET intro2
	call	WriteString
	call	CrLf
;----------------------------------------------------------------------------------------------introduce range
	mov	edx, OFFSET range
	call	WriteString
	call	CrLf
	call	CrLf

;----------------------------------------------------------------------------------------------prompt user for number
	mov	edx, OFFSET getNum
	call	WriteString
;----------------------------------------------------------------------------------------------read input as inputNum
	call	ReadInt	
	mov	inputNum, eax


;----------------------------------------------------------------------------------------------Check range
CheckRange :
;----------------------------------------------------------------------------------------------compare against low end and jump if too low
	mov	eax, inputNum
	cmp	eax, 1	
	jl	OutsideRange
;----------------------------------------------------------------------------------------------compare against high end and jump is too high
	cmp	eax, 46	
	jg	OutsideRange
;----------------------------------------------------------------------------------------------skip if in range
	jmp	InRange


;----------------------------------------------------------------------------------------------if the number is out of range, re-enter number
OutsideRange :
;----------------------------------------------------------------------------------------------warn user out of range
	mov	edx, OFFSET outOfRange
	call	WriteString
	call	CrLf
;----------------------------------------------------------------------------------------------prompt user for number
	mov	edx, OFFSET getNum
	call	WriteString
;----------------------------------------------------------------------------------------------read input as inputNum
	call	ReadInt	
	mov	inputNum, eax
	jmp	CheckRange


;----------------------------------------------------------------------------------------------if number is in range, continue forward
InRange :
;----------------------------------------------------------------------------------------------set up amount of loops
	mov	ecx, inputNum


;----------------------------------------------------------------------------------------------fibonacci terms
Terms:
;----------------------------------------------------------------------------------------------display number, 1 the first time, or result
	mov	eax, term2
	call	WriteDec
	
;----------------------------------------------------------------------------------------------calculate next term
	mov	eax, term1
	add	eax, term2
;----------------------------------------------------------------------------------------------move result into tempterm
	mov	tempterm, eax
;----------------------------------------------------------------------------------------------shift 2nd term to 1st term
	mov	eax, term2
	mov	term1, eax
;----------------------------------------------------------------------------------------------shift result to 2nd term
	mov	eax, tempterm
	mov	term2, eax
;----------------------------------------------------------------------------------------------horizontal tab for spacing
	mov     al, TAB
   	call    WriteChar

;----------------------------------------------------------------------------------------------because if more than 36 terms are displayed, tabs warp columns, see if there are more than 36 terms to be displayed.
	sub	count2, 1
	cmp	count2, 0
;----------------------------------------------------------------------------------------------if so, add a second tab to first 36 terms, then only one tab after
	je	CheckTabs
;----------------------------------------------------------------------------------------------horizontal tab for spacing
	mov     al, TAB
    	call    WriteChar


;----------------------------------------------------------------------------------------------check tabs
CheckTabs :			
;----------------------------------------------------------------------------------------------if reached 36 terms, keep count2 at zero to continue skipping second tab
	cmp	count2, 0	
	je	AddOne	
;----------------------------------------------------------------------------------------------if haven't reached 36 terms, skip addition to continue second tab
	jmp	CheckColumns	


;----------------------------------------------------------------------------------------------add one
AddOne :
;----------------------------------------------------------------------------------------------add one to count2 to keep at zero
	add	count2, 1


;----------------------------------------------------------------------------------------------check columns
CheckColumns :
;----------------------------------------------------------------------------------------------if reached four terms, start new line
	sub	count, 1
	cmp	count, 0
;----------------------------------------------------------------------------------------------else, skip new line and display next term, start next calculation
	jne	LoopAgain
;----------------------------------------------------------------------------------------------if reached four terms, start count to four over again
	mov	count, 4
	call	CrLf
;----------------------------------------------------------------------------------------------loops as many times as user wanted
LoopAgain :
	loop	Terms


;----------------------------------------------------------------------------------------------Say goodbye
	call	CrLf				
	call	CrLf
;----------------------------------------------------------------------------------------------verify results with programmer name
	mov	edx, OFFSET goodbye1
	call	WriteString
	call	CrLf
;----------------------------------------------------------------------------------------------say goodbye with user's name
	mov	edx, OFFSET goodbye2
	call	WriteString
	mov	edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf


;----------------------------------------------------------------------------------------------exit to operating system
	exit
	
main ENDP

END main

TITLE Composite Numbers     (Program03.asm)

; Author: Kelsey Helms
; E-Mail: helmsk@oregonstate.edu
; Course: CS271-400
; Project ID: Program03
; Due date: July 22, 2016                 
; Description: This program will introduce the programmer, get an amount from the user, validate the amount is within range, and produce that many composite numbers.

INCLUDE Irvine32.inc

;----------------------------------------------------------------------------------------------constants
	LOWER = 1
	UPPER = 400

.data

;----------------------------------------------------------------------------------------------messages
	intro			BYTE	"	Composite Numbers		by Kelsey Helms", 0
	EC				BYTE	"**EC: This program displays the numbers in aligned columns.",0
	intro1			BYTE	"Enter the amount of composite numbers you would like to see.",0
	intro2			BYTE	"I will accept orders for up to 400 composites.",0
	instruct		BYTE	"Enter the number of composites to display [1 .. 400]: ",0
	outOfRange		BYTE	"Out of range. Try again please.",0
	goodbye1		BYTE	"Results certified by Kelsey Helms.",0
	goodbye2		BYTE	"Goodbye!",0
;----------------------------------------------------------------------------------------------variables
	rangeNum		DWORD		?
	compositeNum	DWORD		?
	numsPerLine		DWORD		0


.code

;-----------------------------------------------;
; PROC:			main							;
; PURPOSE:		runs program through call list	;
; PARAMETERS:	none							;
; RETURNS:		none							;
;-----------------------------------------------;

main PROC
	call	introduction
	call	getUserData
	call	showComposites
	call	farewell

; exit to operating system
	exit
main ENDP


;-----------------------------------------------;
; PROC:			introduction					;
; PURPOSE:		introduce program				;
; PARAMETERS:	none							;
; RETURNS:		none							;
;-----------------------------------------------;

introduction PROC
;------------------------------------------------Introduce programmer
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
;------------------------------------------------Explain extra credit option
	mov		edx, OFFSET EC
	call	WriteString
	call	CrLf
	call	CrLf
;------------------------------------------------Introduce program concept
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf
;------------------------------------------------Introduce range
	mov		edx, OFFSET intro2
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introduction ENDP


;-----------------------------------------------;
; PROC:			getUserData						;
; PURPOSE:		gets input from user			;
; PARAMETERS:	none							;
; RETURNS:		none							;
;-----------------------------------------------;

getUserData PROC
;------------------------------------------------Prompt user to input number
	mov		edx, OFFSET instruct
	call	WriteString
	call	ReadInt

;------------------------------------------------Read input into rangeNum and call validate procedure
	mov		rangeNum, eax
	call	validate
	call	CrLf
	ret
getUserData ENDP


;-----------------------------------------------;
; PROC:			validate						;
; PURPOSE:		validates user input			;
; PARAMETERS:	none							;
; RETURNS:		none							;
;-----------------------------------------------;

validate PROC
;------------------------------------------------Validate if rangeNum is within given range
	cmp		rangeNum, LOWER
	jl		OutsideRange
	cmp		rangeNum, UPPER
	jg		OutsideRange
	ret

;------------------------------------------------If rangeNum is not in range, display outOfRange message and jump back to get input again
OutsideRange:
	call	CrLf
	mov		edx, OFFSET outOfRange
	call	WriteString
	call	CrLf
	jmp		getUserData
validate ENDP


;-----------------------------------------------;
; PROC:			showComposites					;
; PURPOSE:		displays amount of composites	;
; PARAMETERS:	none							;
; RETURNS:		none							;
;-----------------------------------------------;

showComposites PROC
;------------------------------------------------Set up rangeNum as amount of loops
	mov		ecx, rangeNum
;------------------------------------------------Set up lowest composite and lowest divisor
	mov		eax, 4
	mov		compositeNum, eax
	mov		ebx, 2

DisplayComposite:
;------------------------------------------------Get next composite number
	call	isComposite

;------------------------------------------------Print composite number and increment the number
	mov		eax, compositeNum
	call	WriteDec
	inc		compositeNum

;------------------------------------------------Count the number of integers for each line
	inc		numsPerLine
	mov		eax, numsPerLine
	mov		ebx, 10
	cdq
	div		ebx
	cmp		edx, 0
	je		NewLine
	jne		AddTab

;------------------------------------------------Add new line if 10 numbers in current line
NewLine:
	call	CrLf
	jmp		LoopAgain

;------------------------------------------------Add tab if not 10 numbers to keep columns
AddTab:
	mov     al,  TAB
    call    WriteChar

;------------------------------------------------Loop again
LoopAgain:
	mov		ebx, 2
	mov		eax, compositeNum
	loop	DisplayComposite

	ret
showComposites ENDP


;-----------------------------------------------;
; PROC:			isComposite						;
; PURPOSE:		gets next composite number		;
; PARAMETERS:	none							;
; RETURNS:		none							;
;-----------------------------------------------;

isComposite PROC

FindNext:
;------------------------------------------------Check if number is prime
	cmp		ebx, eax
	je		NotComposite
	
;------------------------------------------------Check if number is composite by dividing and comparing remainder to 0 
	cdq
	div		ebx
	cmp		edx, 0
	je		ItsComposite
	jne		TryAgain

;------------------------------------------------Return if number is composite
ItsComposite:
	ret

;------------------------------------------------If remainder isn't 0, increment divisor, reset compositeNum, and try again 
TryAgain:
	mov		eax, compositeNum
	inc		ebx
	jmp		FindNext

;------------------------------------------------;If number is prime, increment compositeNum, reset divisor, and start over
NotComposite:
	inc		compositeNum
	mov		eax, compositeNum
	mov		ebx, 2
	jmp		FindNext
isComposite ENDP


;-----------------------------------------------;
; PROC:			farewell						;
; PURPOSE:		displays goodbye message		;
; PARAMETERS:	none							;
; RETURNS:		none							;
;-----------------------------------------------;

farewell PROC
	call	CrLf
	call	CrLf
;------------------------------------------------Verify results with programmer name
	mov		edx, OFFSET goodbye1
	call	WriteString
	call	CrLf
;------------------------------------------------Say goodbye
	mov		edx, OFFSET goodbye2
	call	WriteString
	call	CrLf
	call	CrLf
	ret
farewell ENDP

END main

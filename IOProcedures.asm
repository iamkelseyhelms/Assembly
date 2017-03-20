TITLE Designing low-level I/O procedures     (Program05A.asm)

; Author: Kelsey Helms
; E-Mail: helmsk@oregonstate.edu
; Course: CS271-400
; Project ID: Program05A
; Due date: July 29, 2016                 
; Description: This program introduces the programmer, gets a number from the user as a string, converts it to an integer, 
;				finds the sum and average, and converts the integers, sum, and average to strings to display.

INCLUDE Irvine32.inc

;----------------------------------------------------------------------------------------------macros
;-----------------------------------------------;
; MACRO:	getString			;
; PURPOSE:	stores input string in memory	;
; PARAMETERS:	address, size			;
; RETURNS:	none				;
;-----------------------------------------------;

getString	MACRO address, size	
	push		edx
	push		ecx
	mov  		edx, address
	mov  		ecx, size
	call 		ReadString
	pop		ecx
	pop		edx
ENDM


;-----------------------------------------------;
; MACRO:	displayString			;
; PURPOSE:	displays string stored in memory;
; PARAMETERS:	givenString			;
; RETURNS:	none				;
;-----------------------------------------------;

displayString	MACRO givenString
	push		edx
	mov		edx, givenString
	call		WriteString
	pop		edx
ENDM

;----------------------------------------------------------------------------------------------constants
	AMOUNT = 15

.data

;----------------------------------------------------------------------------------------------messages
	intro			BYTE	"   Designing low-level I/O procedures        by Kelsey Helms", 0
	intro1			BYTE	"Please provide 15 unsigned decimal integers.",0
	intro2			BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0
	intro3			BYTE	"After you have finished inputting the raw numbers I will display a",0
	intro4			BYTE	"list of the integers, their sum, and their average value.",0
	instruct		BYTE	"Please enter an unsigned number: ",0
	invalidInput		BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0
	title1			BYTE	"You entered the following numbers:",0
	title2			BYTE	"The sum of these numbers is ",0
	title3			BYTE	"The average is ",0
	goodbye1		BYTE	"Results certified by Kelsey Helms.",0
	goodbye2		BYTE	"Goodbye!",0
;----------------------------------------------------------------------------------------------variables
	userNum			BYTE	255 DUP(0)
	stringTemp		BYTE	32 DUP(0)
	sum			DWORD	?
	average			DWORD	?
	userArray		DWORD	AMOUNT DUP(0)

.code

;-----------------------------------------------;
; PROC:		main				;
; PURPOSE:	runs program through call list	;
; PARAMETERS:	none				;
; RETURNS:	none				;
;-----------------------------------------------;

main PROC
;------------------------------------------------use displayString macro to introduce program
	displayString	OFFSET intro
	call		CrLf
	call		CrLf
	displayString	OFFSET intro1
	call		CrLf
	displayString	OFFSET intro2
	call		CrLf
	displayString	OFFSET intro3
	call		CrLf
	displayString	OFFSET intro4
	call		CrLf
	call		CrLf

;------------------------------------------------set up loop count, set up userArray
	mov		ecx, AMOUNT
	mov		edi, OFFSET userArray
;------------------------------------------------get number input
NextNum:
	displayString	OFFSET instruct
	push		OFFSET userNum
	push		SIZEOF userNum
	call		readVal
;------------------------------------------------insert number into userArray
	mov		eax, DWORD PTR userNum
	mov		[edi], eax
;------------------------------------------------go to next number input
	add		edi, 4
	loop		NextNum

;------------------------------------------------set up loop count, set up userArray, clear sum
	mov		ecx, AMOUNT
	mov		esi, OFFSET userArray
	mov		ebx, 0
;------------------------------------------------introduce user input
	call		CrLf
	displayString	OFFSET title1
	call		CrLf
;------------------------------------------------display user input
NextAddition:
	mov		eax, [esi]
	push		eax
	push		OFFSET stringTemp
	call		writeVal
;------------------------------------------------add user input to sum and move to next user input
	add		ebx, eax
	add		esi, 4
	loop		NextAddition

;------------------------------------------------display sum
	call		CrLf
	displayString	OFFSET title2
	mov		eax, ebx
	mov		sum, eax
	push		sum
	push		OFFSET stringTemp
	call		writeVal
	call		CrLf

;------------------------------------------------calculate average
	mov		ebx, AMOUNT
	mov		edx, 0
	div		ebx
;------------------------------------------------see if average needs to round up
	mov		ecx, eax
	mov		eax, edx
	mov		edx, 2
	mul		edx
;------------------------------------------------by comparing doubled remainder with amount divided by
	cmp		eax, ebx
	mov		eax, ecx
;------------------------------------------------if doubled remainder is less than amount (< 0.5), don't round
	jb		DontRound
	inc		eax
;------------------------------------------------display average
DontRound:
	displayString	OFFSET title3
	mov		average, eax
	push		average
	push		OFFSET stringTemp
	call		WriteVal
	call		CrLf

;------------------------------------------------display farewell
	displayString	OFFSET goodbye1
	call		CrLf
	displayString	OFFSET goodbye2
	call		CrLf
	call		CrLf

;------------------------------------------------exit to operating system
	exit
main ENDP


;-----------------------------------------------;
; PROC:		readVal				;
; PURPOSE:	gets numbers and moves to array	;
; PARAMETERS:	userArray, invalidInput, userNum;
; RETURNS:	userArray			;
;-----------------------------------------------;

readVal PROC
;------------------------------------------------set up stack frame
	push		ebp
	mov		ebp, esp
	pushad
;------------------------------------------------set up number input variables and get the string from user
GetNum:
	mov		edx, [ebp+12]
	mov		ecx, [ebp+8]
	getString	edx, ecx
;------------------------------------------------set up registers
	mov		esi, edx
	mov		eax, 0
	mov		ecx, 0
	mov		ebx, 10
;------------------------------------------------load the string in by byte
NextByte:
	lodsb					
	cmp		ax, 0		
	je		Finished
;------------------------------------------------check that input is a digit
	cmp		ax, 48				
	jb		NotValid
	cmp		ax, 57				
	ja		NotValid
;------------------------------------------------convert char to integer
	sub		ax, 48
	xchg		eax, ecx
;------------------------------------------------multiply by 10 for correct place, then check carry flag
	mul		ebx				
	jc		NotValid
	jnc		Continue
;------------------------------------------------error if not digit or if number is too big
NotValid:
	displayString	OFFSET invalidInput
	call		CrLf
	displayString	OFFSET instruct
	jmp		GetNum
;------------------------------------------------get next byte
Continue:
	add		eax, ecx
	xchg		eax, ecx		
	jmp		NextByte	
;------------------------------------------------save integer into userNum
Finished:
	xchg		ecx, eax
	mov		DWORD PTR userNum, eax	
;------------------------------------------------reset stack
	popad
	pop ebp
	ret 8

readVal ENDP


;-----------------------------------------------;
; PROC:		writeVal			;
; PURPOSE:	gets numbers and moves to array	;
; PARAMETERS:	userArray, invalidInput, userNum;
; RETURNS:	userArray			;
;-----------------------------------------------;

writeVal PROC
;------------------------------------------------set up stack frame
	push		ebp
	mov		ebp, esp
	pushad
;------------------------------------------------set up number, string, and divisor
	mov		eax, [ebp+12]
	mov		edi, [ebp+8]
	mov		ebx, 10
	push		0
;------------------------------------------------convert smallest digit to ascii char number
ConvertNums:
	mov		edx, 0
	div		ebx
	add		edx, 48
	push		edx
	cmp		eax, 0
	jne		ConvertNums
;------------------------------------------------store digits in stringTemp
PopNums:
	pop		eax
	stosb
	cmp		eax, 0
	jne		PopNums
;------------------------------------------------display number converted to string
	displayString	OFFSET stringTemp
	call		CrLf
;------------------------------------------------reset stack
	popad
	pop		ebp
	ret		8
 
writeVal ENDP

END main

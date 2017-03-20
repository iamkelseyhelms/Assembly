TITLE Random Sorted Integers    (Program04.asm)

; Author: Kelsey Helms
; E-Mail: helmsk@oregonstate.edu
; Course: CS271-400
; Project ID: Program04
; Due date: July 27, 2016                 
; Description: This program will introduce the programmer, get an amount from the user, and validate the amount is within range.
;It will then produce that many random integers, find the median, and reproduce the same integers in sorted descending order.

INCLUDE Irvine32.inc

;----------------------------------------------------------------------------------------------constants
	LO = 100
	HI = 999
	MIN = 10
	MAX = 200

.data

;----------------------------------------------------------------------------------------------messages
	intro			BYTE	"	Random Sorted Integers		by Kelsey Helms", 0
	intro1			BYTE	"This program generates random numbers in the range [100 .. 999],",0
	intro2			BYTE	"displays the original list, sorts the list, and calculates the",0
	intro3			BYTE	"median value.  Finally, it displays the list sorted in descending order.",0
	instruct		BYTE	"How many numbers should be generated? [10 .. 200]: ",0
	outOfRange		BYTE	"Invalid input. Try again please.",0
	title1			BYTE	"This is the unsorted list:",0
	title2			BYTE	"This is the sorted list:",0
	title3			BYTE	"The median is ",0
	goodbye1		BYTE	"Results certified by Kelsey Helms.",0
	goodbye2		BYTE	"Goodbye!",0
;----------------------------------------------------------------------------------------------variables
	userNum			DWORD	?
	userArray		DWORD	200 DUP(0)


.code

;-----------------------------------------------;
; PROC:		main				;
; PURPOSE:	runs program through call list	;
; PARAMETERS:	none				;
; RETURNS:	none				;
;-----------------------------------------------;

main PROC
;------------------------------------------------pass all intro messages as arguments and call introduction procedure
	push	OFFSET intro
	push	OFFSET intro1
	push	OFFSET intro2
	push	OFFSET intro3
	call	introduction
;------------------------------------------------pass instructions, userNum, and outOfRange as arguments and call getUserData procedure
	push	OFFSET instruct
	push	OFFSET userNum
	push	OFFSET outOfRange
	call	getUserData
;------------------------------------------------pass userArray and userNum as arguments and call fillArray procedure
	push	OFFSET userArray
	push	userNum
	call	fillArray
;------------------------------------------------pass title1, userArray and userNum as arguments and call displayList procedure
	push	OFFSET title1
	push	OFFSET userArray
	push	userNum
	call	displayList
;------------------------------------------------pass userArray and userNum as arguments and call sortList procedure
	push	OFFSET userArray
	push	userNum
	call	sortList
;------------------------------------------------pass title3, userArray, and userNum as arguments and call displayMedian procedure
	push	OFFSET title3
	push	OFFSET userArray
	push	userNum
	call	displayMedian
;------------------------------------------------pass title2, userArray, and userNum as arguments and call displayList procedure
	push	OFFSET title2
	push	OFFSET userArray
	push	userNum
	call	displayList
;------------------------------------------------pass all goodbye messages as arguments and call farewell procedure
	push	OFFSET goodbye1
	push	OFFSET goodbye2
	call	farewell

;------------------------------------------------exit to operating system
	exit
main ENDP


;-----------------------------------------------;
; PROC:		introduction			;
; PURPOSE:	introduce program		;
; PARAMETERS:	intro, intro1, intro2, intro3	;
; RETURNS:	none				;
;-----------------------------------------------;

introduction PROC
;------------------------------------------------set up stack frame
	push	ebp
	mov	ebp, esp
;------------------------------------------------access intro and display
	mov	edx, [ebp+20]
	call	WriteString
	call	CrLf
;------------------------------------------------access intro1 and display
	mov	edx, [ebp+16]
	call	WriteString
	call	CrLf
;------------------------------------------------access intro2 and display
	mov	edx, [ebp+12]
	call	WriteString
	call	CrLf
;------------------------------------------------access intro3 and display
	mov	edx, [ebp+8]
	call	WriteString
	call	CrLf
	call	CrLf
;------------------------------------------------reset ebp and return with 4 messages
	pop	ebp
	ret	16

introduction ENDP


;-----------------------------------------------;
; PROC:		getUserData			;
; PURPOSE:	gets input from user		;
; PARAMETERS:	instruct, userNum, outOfRange	;
; RETURNS:	filled userNum			;
;-----------------------------------------------;

getUserData PROC
;------------------------------------------------set up stack frame
	push	ebp
	mov	ebp, esp
;------------------------------------------------access instruct and display
GetNum:
	mov	edx, [ebp+16]
	call	WriteString
;------------------------------------------------read user input and store in userNum variable in stack
	call	ReadInt
	mov	ebx, [ebp+12]
	mov	[ebx], eax
;------------------------------------------------validate user input
	cmp	eax, MIN
	jl	OutsideRange
	cmp	eax, MAX
	jg	OutsideRange
;------------------------------------------------reset ebp and return with 2 messages and 1 variable
	call	CrLf
	pop	ebp
	ret	12
;------------------------------------------------access outOfRange and display, then re-start GetNum
OutsideRange:
	call	CrLf
	mov	edx, [ebp+8]
	call	WriteString
	call	CrLf
	jmp	GetNum

getUserData ENDP


;-----------------------------------------------;
; PROC:		fillArray			;
; PURPOSE:	fills array with random numbers	;
; PARAMETERS:	userArray, userNum		;
; RETURNS:	filled userArray		;
;-----------------------------------------------;

fillArray PROC
;------------------------------------------------set up stack frame
	push	ebp
	mov	ebp, esp
;------------------------------------------------set up userNum as loop count, set up userArray and randomization
	mov	edi, [ebp+12]
	mov	ecx, [ebp+8]
	call	Randomize
;------------------------------------------------get random number within range of 100-999
Next:
	mov	eax, hi				 
	sub	eax, lo
	inc	eax
	call	RandomRange
	add	eax, lo
;------------------------------------------------put number in array, increment array element, and repeat
	mov	[edi], eax
	add	edi, 4
	loop	Next
;------------------------------------------------reset ebp and return with 2 variables
	pop	ebp
	ret	8

fillArray ENDP


;-----------------------------------------------;
; PROC:		sortList			;
; PURPOSE:	sorts array in descending order	;
; PARAMETERS:	userArray, userNum		;
; RETURNS:	sorted userArray		;
;-----------------------------------------------;

sortList PROC
;------------------------------------------------set up stack frame
	push	ebp
	mov	ebp, esp
;------------------------------------------------set up userNum as loop count
	mov	ecx, [ebp+8]
	dec	ecx
;------------------------------------------------initilize outer loop with userArray at beginning, save OuterLoop count
OuterLoop:			
	mov	esi, [ebp+12]
	push 	ecx	
;------------------------------------------------InnerLoop compares two neighboring elements (x, x+1)
InnerLoop:
	mov	eax, [esi]
	cmp	eax, [esi+4]
;------------------------------------------------skip exchange if x is greater than x+1
	jg	LoopInnLoop
;------------------------------------------------if x is less than x+1, pass both elements as arguments to exchange procedure
	push	[esi]
	push	[esi+4]
	call 	exchange
;------------------------------------------------receive both elements back, now switched
	pop	[esi+4]
	pop	[esi]
;------------------------------------------------repeat InnerLoop
LoopInnLoop:
	add	esi, 4
	loop	InnerLoop
;------------------------------------------------get OuterLoop count and repeat OuterLoop
	pop 	ecx
	loop 	OuterLoop
;------------------------------------------------reset ebp and return with 2 variables
	pop	ebp
	ret 	8

sortList ENDP


;-----------------------------------------------;
; PROC:		exchange			;
; PURPOSE:	swaps two elements		;
; PARAMETERS:	element x, element x+1		;
; RETURNS:	element x, element x+1 swapped	;
;-----------------------------------------------;

exchange PROC
;------------------------------------------------set up stack frame and push all registers to preserve sortList
	push	ebp
	mov	ebp, esp
;------------------------------------------------move element[x] in temp
	mov	ebx, [ebp+12] 		
;------------------------------------------------move element[x+1] in temp
	mov 	edx, [ebp+8]
;------------------------------------------------swap
	mov	[ebp+12], edx
	mov	[ebp+8], ebx
;------------------------------------------------reset ebp and return
	pop	ebp
	ret 	
exchange ENDP


;-----------------------------------------------;
; PROC:		displayMedian			;
; PURPOSE:	displays array median		;
; PARAMETERS:	title, userArray, userNum	;
; RETURNS:	none				;
;-----------------------------------------------;

displayMedian PROC
;------------------------------------------------set up stack frame
	push	ebp
	mov	ebp, esp
;------------------------------------------------access title and display
	mov	edx, [ebp+16]
	call	WriteString
	call	CrLf
;------------------------------------------------set up userArray, userNum, and divisor
	mov	edi, [ebp+12]
	mov	eax, [ebp+8]
	cdq
	mov	ebx, 2
;------------------------------------------------find the middle of userArray
	div	ebx
	shl	eax, 2
	add	edi, eax
	mov	eax, [edi]
	cmp	edx, 0
	je	EvenArray
	jmp	DisplayNum
;------------------------------------------------find the median for an even array
EvenArray:
	sub	edi, 4
	add	eax, [edi]
	div	ebx
DisplayNum:
	call	WriteDec
	call	CrLf
	call	CrLf
;------------------------------------------------reset ebp and return with 1 message and 2 variables
	pop	ebp
	ret	12

displayMedian ENDP


;-----------------------------------------------;
; PROC:		displayList			;
; PURPOSE:	displays current array		;
; PARAMETERS:	title, userArray, userNum	;
; RETURNS:	none				;
;-----------------------------------------------;

displayList PROC
;------------------------------------------------set up stack frame
	push	ebp
	mov	ebp, esp
;------------------------------------------------access title and display
	mov	edx, [ebp+16]
	call	WriteString
	call	CrLf
;------------------------------------------------set up userNum as loop count, edx as element counter, and set up userArray
	mov	esi, [ebp+12]
	mov	ecx, [ebp+8]
	mov	ebx, 0
;------------------------------------------------get current element, display, and set up next element
More:
	mov	eax, [esi]
	call	WriteDec
	add	esi, 4
;------------------------------------------------Count the number of integers for each line
	inc	ebx
	cmp	ebx, 10
	je	NewLine
	mov     al, TAB
    	call    WriteChar
	jmp	LoopAgain
;------------------------------------------------Add new line if 10 numbers in current line
NewLine:
	call	CrLf
	mov	ebx, 0
;------------------------------------------------Loop again
LoopAgain:
	loop	More
;------------------------------------------------reset ebp and return with 1 message and 2 variables
	call	CrLf
	call	CrLf
	pop	ebp
	ret	12

displayList ENDP


;-----------------------------------------------;
; PROC:		farewell			;
; PURPOSE:	displays goodbye message	;
; PARAMETERS:	none				;
; RETURNS:	none				;
;-----------------------------------------------;

farewell PROC
;------------------------------------------------set up stack frame
	push	ebp
	mov	ebp, esp
;------------------------------------------------Verify results with programmer name
	mov	edx, [ebp+12]
	call	WriteString
	call	CrLf
;------------------------------------------------Say goodbye
	mov	edx, [ebp+8]
	call	WriteString
	call	CrLf
	call	CrLf
	pop	ebp
	ret	8

farewell ENDP

END main

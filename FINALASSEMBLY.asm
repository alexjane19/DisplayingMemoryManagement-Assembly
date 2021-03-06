stack   segment para stack 'STACK'
        db      512 dup(?)
stack   ends

    VGA_VIDEO_SEGMENT       	equ     0a000h  	;VGA display memory segment
    SCREEN_WIDTH_IN_BYTES   	equ     044ah   	;offset of BIOS variable
    FONT_CHARACTER_SIZE     	equ     14      	;# bytes in each font char
;
; VGA register equates.
;
    SC_INDEX        		equ     3c4h    	;SC index register
    SC_MAP_MASK     		equ     2       	;SC map mask register index
    GC_INDEX        		equ     3ceh    	;GC index register
    GC_SET_RESET    		equ     0       	;GC set/reset register index
    GC_ENABLE_SET_RESET 	equ 	1       	;GC enable set/reset register index
    GC_ROTATE       		equ     3       	;GC data rotate/logical function
                         	       	; register index
    GC_MODE         		equ     5       	;GC Mode register
    GC_BIT_MASK     		equ     8       	;GC bit mask register index
;

data segment para common 'DATA'
    ; add your data here!
;---------varibale for font-----------
  
    TEST_TEXT_ROW   		DW     25      	;row to display test text at
    TEST_TEXT_COL   		DW     48      	;column to display test text at
    TEST_TEXT_COLOR 		DB     0fh     	;high intensity white
TestString      label   byte
        db      57H,37H,0         	;test string to print.
    FontPointer     dd      ?          
      
;-----------END---varibale for font-----------------------    
     
     
   SPOINT DW 20
   EPOINT DW ?
   PMEM DW ?    ;size of page with pixel
   SPAGE DB ?   ;real size of page
   
   MENU1 DB '1.SHOW MEMORY','$'
   MENU2 DB 0AH,0DH,'2.INPUT NEW PROGRAM','$'
   MENU3 DB 0AH,0DH,'3.CALCULATION HIT RATE','$'
   MENU4 DB 0AH,0DH,'4.END TASK','$'
   MENU5 DB 0AH,0DH,'5.SHOW PROGRAMS IN VIRTUAL MEMORY','$'
   MENU6 DB 0AH,0DH,'6.EXIT','$'
   MENU31 DB 0AH,0DH,'1.Random','$'
   MENU32 DB 0AH,0DH,'2.Optional','$'                              
   MSG1 DB 'Enter Size Memory:','$'
   MSG2 DB 0AH,0DH,'Enter Size Page:','$'   
   MSG3 DB 0AH,0DH,'Enter a Name Program:','$'
   MSG4 DB 0AH,0DH,'Enter Size of Program:','$' 
   MSG5 DB 0AH,0DH,'For back main menu(N) or Contine to input new porgram(Y)','$'
   MSGHRATE DB 'Hit Rate:',0AH,0DH,'$'
   MSGETASK DB 'End Task Menu:','$'
   MSGNPROG DB 'New Program Menu:','$'
   MSGSPROG DB 'Programs In Virtual Memory:',0AH,0DH,'$'  
   MSGPMEM  DB 'Programs In Memory:',0AH,0DH,'$'
   MSGPAGEOPT DB 0AH,0DH,'Enter Name of a Program:','$'
   ALLOCATING DB 'Allocating','$'
                
   
   SIZEMEMORY LABEL BYTE
   MAXLEN1 DB 20
   ACTELN1 DB ?
   KBDATA1 DB 20 DUP(' ')
    
   NPROGRAM LABEL BYTE
   MAXLEN DB 20
   ACTELN DB ?
   KBDATA DB 20 DUP(' ')  
   
   NAMEPROG LABEL BYTE
   NPMAXLEN DB 20
   NPACTELN DB ?
   NPKBDATA DB 20 DUP(?) 
   
   SIZEPROG LABEL BYTE
   SPMAXLEN DB 20
   SPACTELN DB ?
   SPKBDATA DB 20 DUP(?)
   
   
   TEMPWORD LABEL BYTE
   MAXLENTEMP DB 20
   ACTELNTEMP DB ?
   KBDATATEMP DB 20 DUP(' ') 
   
   SIZEMEM DB ? ;real size of memory
   
   NUMPAGEMEM DB ?
   
   STARTLPR DW ?
   ENDLPR DW ?
   LISTPROGRAM DB 40 DUP(0)
   
   STARTLPA DW ?
   ENDLPA DW ?
   LISTPAGE DB 100 DUP(0)
   NUMPAGEVIRTU DB 00
   
   OFFSETPAGE DW 40 DUP(0)
   NUMOFPAGEP DB 40 DUP(0)
   NUMOFPROG DB 0H
   STARTLISTPAGE DW ?
   NUMPAGEV DB ?
   DIT DW ?
   SIT DW ?
   CXT DW ? 
   DIX DW ?
   
   HITRATE DB 100 DUP(0) 
   ASC_NUM    DB  4 DUP(0)
   
   PTRLM DW ?
   STARTLM DW ?
   ENDLM DW ?   
   LISTMEMORY DB 50 DUP(0) 
   
   RANDNUM DB ?
   DIVRANDM DB ?
   
   AVAILBPAGE DB 0
  
   COUNTENDLIST DW ? 
   
   STARTLIST DW ?
   ENDLIST   DW ?
    
ends

code segment  
    assume cs:code,ds:data,ss:stack
    
MAIN PROC FAR
; set segment registers:
    MOV AX, DATA
    MOV DS, AX 
    
 
;	----------------------------- 
    MOV STARTLPR,OFFSET LISTPROGRAM
    MOV STARTLPA,OFFSET LISTPAGE
    MOV STARTLM,OFFSET LISTMEMORY
    MOV AX,STARTLPR
    MOV ENDLPR,AX
    MOV AX,STARTLPA
    MOV ENDLPA,AX
    MOV AX,STARTLM
    MOV PTRLM,AX   
     
    CALL SETSIZEMEMPAGE
    CALL CLRSCR
    
    
    STARTPRG: 
    LEA DX,ALLOCATING
    MOV AH,09H
    INT 21H
    
    STARTPRG1: 
    MOV CX,00
    MOV CL,NUMOFPROG
    LEA SI,OFFSETPAGE
    LEA DI,NUMOFPAGEP
    

    
    
    CMP CX,0
    JZ NOTREPETE 
    REPET:
  
    
    MOV AL,[DI]
    MOV NUMPAGEV,AL
    MOV AX,00
    MOV AX,[SI] 
    MOV STARTLISTPAGE,AX
    MOV SIT,SI
    MOV DIT,DI
    MOV CXT,CX
        
    CALL ALLOCMEMPAGE
        
    MOV AH,01H
    INT 16H
    JNZ NOTREPETE
    
    MOV DL,2EH
    MOV AH,02
    INT 21H
    MOV BX,09FFH 
    AGAIN1:MOV CX,0
    AGAIN: LOOP AGAIN
    DEC BX
    JNZ AGAIN1
    MOV SI,SIT
    MOV DI,DIT
    MOV CX,CXT 
    ADD SI,2
    ADD DI,2
    DEC CX
     
    CMP CX,0
    JG REPET
    CMP CX,0
    JE STARTPRG1
    
    NOTREPETE:
    
    CALL LOCATEPAGE
    
    
    LEA DX,MENU1
    MOV AH,09H
    INT 21H
        
    LEA DX,MENU2
    MOV AH,09H
    INT 21H
        
    LEA DX,MENU3
    MOV AH,09H
    INT 21H
        
    LEA DX,MENU4
    MOV AH,09H
    INT 21H
        
    LEA DX,MENU5
    MOV AH,09H
    INT 21H
    
    LEA DX,MENU6
    MOV AH,09H
    INT 21H
    
    MOV AH,0CH
    MOV AL,7H
    INT 21H
    
    ;MOV AH,7H
   ; INT 21H 
    
    CMP AL,31H
    JNE MEN2
    CALL LOCATEPAGE
    MOV AL,00
    
    MEN2: 
    
    CMP AL,32H
    JNE MEN3
    CALL SETPROGRAM
    MOV AL,00
    
    MEN3:
    
    
    CMP AL,33H 
    JNE MEN4
    CALL CALCHITRATE       
    MOV AL,00
    
    
    MEN4:
    
    
    CMP AL,34H
    JNE MEN5
    CALL CLRSCR
    LEA DX,MSGETASK
    MOV AH,09H
    INT 21H      
    LEA DX,MENU31
    MOV AH,09H
    INT 21H        
    LEA DX,MENU32
    MOV AH,09H
    INT 21H
    
    MOV AH,7H
    INT 21H
        
    CMP AL,31H 
    JNE MEN42
    CALL FREEMEMPAGE
    CALL LOCATEPAGE
    MOV AL,00
    
    MEN42:        
    CMP AL,32H 
    JNE MEN5
    CALL FREEMEMPAGEOPTIC
    CALL LOCATEPAGE
    MOV AL,00       
    
    
    MEN5:  
    
    
    
    CMP AL,35H ;SHOW PROGRAMS IN VIRTUAL MEMORY
    JNE MEN6
    CALL SHOWPROGRAM
    
    MEN6:
    
    CMP AL,36H
    JNE ENDMEN
    mov ax, 4c00h ; exit to operating system.
    int 21h 
    ENDMEN:
    
    
    
    mov     ah,1
    int     21h     		;wait for a key
    mov     ax,3
    int     10h
    MOV AH,0CH
    INT 21H      
    JMP STARTPRG
    ;CALL DRAWMEMORY
     
    ;CALL CLEARMENU
    ;CALL SETPROGRAM
    ;CALL SETPROGRAM
    
    ;CALL ALLOCMEMPAGE
   ; CALL ALLOCMEMPAGE                
   ; ;CALL ALLOCMEMPAGE
   ; CALL ALLOCMEMPAGE
   ; CALL FREEMEMPAGE
   ; CALL FREEMEMPAGE
   ; CALL ALLOCMEMPAGE
    ;CALL DRAWMEMORY
  ;  CALL LOCATEPAGE
    ; wait for any key....    
 
MAIN ENDP
CODE ENDS  

CALCHITRATE PROC NEAR
    CALL CLRSCR
    LEA DX,MSGHRATE
    MOV AH,09H
    INT 21H
    
    LEA DI,HITRATE
    NEXTWORD11:
    
    MOV BL,[DI]
    CMP BL,0000
    JE NEXTLETER1
    PRTSTR11:
    
    MOV DL,BL
    MOV AH,02
    INT 21H
    INC DI
    MOV BL,[DI]
    CMP BL,40H
    JGE PRTSTR11
    
    MOV DL,BL
    MOV AH,02
    INT 21H
    
    MOV DL,3AH
    MOV AH,02
    INT 21H 
    

    INC DI
    MOV AX,0
    MOV BL,[DI]
    MOV CX,10     ;3-Move 10 to CX
    LEA SI,ASC_NUM ;4- SI=Offset ASC_NUM
    ADD SI,2      ;5-SI point to last ascii
    MOV AL,BL ;6-Move  124BH to AX
    BACK11:    MOV DX,0      ;7-Move 0 to DX
    DIV CX        ;8-Divide DX:AX to 10
    OR DL,30H     ;9-Make remainder ascii
    MOV [SI],DL   ;10-Put ascii in ASC_NUM
    DEC SI        ;11-SI point to next ascii
    CMP AX,0      ;12-If AX>0 go
    JA BACK11 
    
    
    CHOP:
    MOV DL,[SI]
    MOV AH,02
    INT 21H
    INC SI
    CMP [SI],0
    JNE CHOP
    
    MOV DL,2FH
    MOV AH,02
    INT 21H
    
    
    INC DI 
    MOV AX,00
    MOV BL,[DI]
    MOV CX,10     ;3-Move 10 to CX
    LEA SI,ASC_NUM ;4- SI=Offset ASC_NUM
    ADD SI,2      ;5-SI point to last ascii
    MOV AL,BL ;6-Move  124BH to AX
    BACK12:    MOV DX,0      ;7-Move 0 to DX
    DIV CX        ;8-Divide DX:AX to 10
    OR DL,30H     ;9-Make remainder ascii
    MOV [SI],DL   ;10-Put ascii in ASC_NUM
    DEC SI        ;11-SI point to next ascii
    CMP AX,0      ;12-If AX>0 go
    JA BACK12 
    
    
    CHOP1:
    MOV DL,[SI]
    MOV AH,02
    INT 21H
    INC SI
    CMP [SI],0
    JNE CHOP1
    
    MOV DL,2AH
    MOV AH,02
    INT 21H
    
     MOV DL,31H
    MOV AH,02
    INT 21H
    
     MOV DL,30H
    MOV AH,02
    INT 21H
    
     MOV DL,30H
    MOV AH,02
    INT 21H
        
    MOV DL,0AH
    MOV AH,02
    INT 21H 
    MOV DL,0DH
    MOV AH,02
    INT 21H
            
        
    NEXTLETER1:
    INC DI
    CMP [DI],000
    JNE NEXTWORD11

    


    RET
    CALCHITRATE ENDP

SHOWPROGRAM PROC NEAR
    CALL CLRSCR
    LEA DX,MSGSPROG
    MOV AH,09H
    INT 21H
    
    MOV DI,STARTLPR
    MOV CL,30H
    NEXTWORD:
    INC CL
    MOV DL,CL
    MOV AH,02
    INT 21H
    
    MOV DL,2EH
    MOV AH,02
    INT 21H
    
    MOV BL,[DI]
    PRTSTR:
    
    MOV DL,BL
    MOV AH,02
    INT 21H
    INC DI
    MOV BL,[DI]
    CMP BL,40H
    JGE PRTSTR
    
    MOV DL,1AH
    MOV AH,02
    INT 21H
     
    GETCOM:
    MOV BL,[DI]
    CMP BL,30H
    JNGE BREAK 
    MOV DL,BL
    MOV AH,02
    INT 21H
    INC DI
    CMP [DI],40H
    JL GETCOM
    
    BREAK:
    MOV DL,4DH
    MOV AH,02
    INT 21H
    MOV DL,42H
    MOV AH,02
    INT 21H
    
    MOV DL,0AH
    MOV AH,02
    INT 21H 
    MOV DL,0DH
    MOV AH,02
    INT 21H
    
    CMP DI,ENDLPR
    JL NEXTWORD
    
    
    RET
SHOWPROGRAM ENDP    



SHOWPAGE PROC NEAR
    CALL CLRSCR
    LEA DX,MSGPMEM ;Pages:
    MOV AH,09H
    INT 21H 
    
    MOV DI,STARTLPR
    MOV CL,30H
    NEXTWORD112:
    INC CL
    MOV DL,CL
    MOV AH,02
    INT 21H
    
    MOV DL,2EH
    MOV AH,02
    INT 21H
    
    MOV BL,[DI]
    PRTSTR112:
    
    MOV DL,BL
    MOV AH,02
    INT 21H
    INC DI
    MOV BL,[DI]
    CMP BL,40H
    JGE PRTSTR112
    
    MOV DL,0AH
    MOV AH,02
    INT 21H 
    MOV DL,0DH
    MOV AH,02
    INT 21H
    NEXTELEMNT:
    INC DI
    CMP [DI],40H
    JL NEXTELEMNT
    CMP DI,ENDLPR
    JL NEXTWORD112
    
    RET
SHOWPAGE ENDP  
  



LOCATEPAGE PROC NEAR
    CALL DRAWMEMORY
    MOV DI,STARTLM
    MOV COUNTENDLIST,DI
    LLL:
    MOV AX,ENDLM
    CMP AX,COUNTENDLIST
    JLE ENDFUNLO
    MOV DI,COUNTENDLIST 
    MOV AX,[DI]
    ADD DI,2
    MOV COUNTENDLIST,DI
    CMP AX,0000
    JE LLL
    mov si,offset TestString
    MOV [SI],AX 
    CALL PRINT
     XOR BX,BX
        XOR AH,AH
        MOV BX,PMEM
        MOV AH,2
        ADD BX,TEST_TEXT_ROW
        ADD AH,TEST_TEXT_COLOR
        MOV TEST_TEXT_ROW,BX
        MOV TEST_TEXT_COLOR,AH
    MOV AX,ENDLM
    CMP AX,COUNTENDLIST
    
    JG LLL
    ENDFUNLO: 
    MOV BX,25
    MOV TEST_TEXT_ROW,BX
    
    MOV AH,0CH 
    mov aL,1
    INT 21H  
    mov     ax,3
    int     10h

    RET
LOCATEPAGE ENDP

FREEMEMPAGE PROC NEAR
    CMP AVAILBPAGE,0
    JE ENDFREE
    BACKFUN1:
    XOR AX,AX      
    MOV AL,NUMPAGEMEM
    MOV CL,2
    MUL CL
    SUB AL,2            
    MOV DIVRANDM,AL 
    XOR AX,AX 
    CALL GENERANDNUM             
    MOV DI,STARTLM
    MOV BX,0000
    MOV BL,RANDNUM
    ADD DI,BX
    MOV BX,0000
    MOV BX,[DI]
    CMP BX,0000
    JE BACKFUN1
    MOV AX,0000
    MOV [DI],AX
    
    CMP DI,PTRLM
    JNE FRONTH1
    ADD DI,2
    CMP DI,ENDLM
    JLE FRONTH2 
    MOV DI,STARTLM
    FRONTH2:
    MOV PTRLM,DI
    FRONTH1:
    
    SUB AVAILBPAGE,1 
    ENDFREE:
    RET
    FREEMEMPAGE ENDP

FREEMEMPAGEOPTIC PROC NEAR 

    CALL SHOWPAGE
    
    LEA DX,MSGPAGEOPT 
    MOV AH,09H
    INT 21H
    
    MOV AH,0AH
    LEA DX,TEMPWORD
    INT 21H
    
    CMP AVAILBPAGE,0
    JE ENDFREE1
    
    
    
    LEA DI,KBDATATEMP
    MOV AL,[DI]
         
               
    MOV DI,STARTLM
    SUB DI,2
    BACKFUN111:
    ADD DI,2
    MOV BX,[DI]
    CMP BL,AL
    JE FINDELEM
    CMP DI,ENDLM
    JL BACKFUN111
    
    FINDELEM:
    CMP BL,AL
    JNE ENDFREE1
    SUB AVAILBPAGE,1
    MOV AX,0000
    MOV [DI],AX
    
    
    MOV DIX,DI
    
    CMP DI,PTRLM
    JNE FRONTH111
    ADD DI,2
    CMP DI,ENDLM
    JLE FRONTH112 
    MOV DI,STARTLM
    FRONTH112:
    MOV PTRLM,DI
    FRONTH111:
    
    LEA DI,KBDATATEMP
    MOV AL,[DI]
    
    MOV DI,DIX
    CMP DI,PTRLM
    JNE BACKFUN111
    
    ENDFREE1:
    RET
    FREEMEMPAGEOPTIC ENDP



ALLOCMEMPAGE PROC NEAR
    MOV BL,AVAILBPAGE
    CMP BL,NUMPAGEMEM
    JGE FULLMEM
    BACKFUN:
    XOR AX,AX      
    MOV AL,NUMPAGEV
    MOV CL,2
    MUL CL
    SUB AL,2            
    MOV DIVRANDM,AL 
    XOR AX,AX      
    CALL GENERANDNUM             
    MOV DI,STARTLISTPAGE
    MOV BX,0000
    MOV BL,RANDNUM
    ADD DI,BX
    MOV BX,0000
    MOV BX,[DI]
    MOV SI,STARTLM
    
    MOV DX,0H
    
    FINDX12:
    MOV AX,[SI]
    CMP AX,BX
    JE FRONTX12
    ADD SI,2
    CMP SI,ENDLM
    JL FINDX12
    
    
    
     
    CMP AX,BX
    JNE NOTCHECK
    FRONTX12:
    MOV DL,1H
    
    NOTCHECK:
    
    LEA DI,HITRATE
    SUB DI,4
    CHECKHIT:
    ADD DI,4
    MOV AX,[DI]
    CMP AX,BX
    JE HITFOUND
    CMP AX,0000
    JNE CHECKHIT
    
    
    HITFOUND:
    MOV [DI],BX
    ADD DI,2
    ADD [DI],DL
    INC DI
    ADD [DI],1H
    
    CMP BX,[SI]
    JE ENDFUN
    
    MOV SI,STARTLM 
     
    FINDX:
    MOV AX,[SI]
    CMP AX,0000
    JE FRONTX
    ADD SI,2
    CMP SI,ENDLM
    JL FINDX
        
    FRONTX:
    MOV [SI],BX ;FINDX [SI]=0000
     
    ADD AVAILBPAGE,1 
    MOV BX,0000
    MOV BL,AVAILBPAGE
    CMP BL,NUMPAGEMEM
    JLE ENDFUN
    
    FULLMEM:
    
    
    BACKFUN2:
    XOR AX,AX      
    MOV AL,NUMPAGEV
    MOV CL,2
    MUL CL
    SUB AL,2            
    MOV DIVRANDM,AL 
    XOR AX,AX 
    CALL GENERANDNUM             
    MOV DI,STARTLISTPAGE
    MOV BX,0000
    MOV BL,RANDNUM
    ADD DI,BX
    MOV BX,0000
    MOV BX,[DI]

    MOV SI,STARTLM
    
    MOV DX,0H
    
    FINDX122:
    MOV AX,[SI]
    CMP AX,BX
    JE FRONTX122
    ADD SI,2
    CMP SI,ENDLM
    JL FINDX122
    
    
    
     
    CMP AX,BX
    JNE NOTCHECK1
    FRONTX122:
    MOV DL,1H
    
    NOTCHECK1:
    
    LEA DI,HITRATE
    SUB DI,4
    CHECKHIT1:
    ADD DI,4
    MOV AX,[DI]
    CMP AX,BX
    JE HITFOUND1
    CMP AX,0000
    JNE CHECKHIT1
    
    
    HITFOUND1:
    MOV [DI],BX
    ADD DI,2
    ADD [DI],DL
    INC DI
    ADD [DI],1H


    CMP BX,[SI]
    JE ENDFUN
    
    MOV SI,PTRLM
   
    MOV [SI],BX
    
    ADD SI,2 
    CMP SI,ENDLM
    JL FRONTER
    MOV SI,STARTLM 
    FRONTER:
    MOV PTRLM,SI
    
    ENDFUN: 
 
    RET
ALLOCMEMPAGE ENDP

GENERANDNUM PROC NEAR 
    
    XOR CX,CX
    MOV AH, 00h  ; interrupts to get system time        
    INT 1AH 
    
    CMP DIVRANDM,0
    JNE OKEY
    ADD DIVRANDM,1
           
           
    OKEY:       
    mov  ax, dx
    xor  dx, dx
    mov  cl, DIVRANDM    
    div  cx       ; here dx contains the remainder of the division - from 0 to 9
    
     
    MOV AX,DX
    MOV CL,2
    DIV CL
    CMP AH,00
    JZ NEXTR
    ADD DL,1
    
    NEXTR:
    MOV RANDNUM,DL
    RET
    GENERANDNUM ENDP
    
SETSIZEMEMPAGE PROC NEAR
    LEA DX,MSG1
    MOV AH,09H
    INT 21H
    
    MOV AH,0AH
    LEA DX,SIZEMEMORY
    INT 21H 
    
    MOV SI,OFFSET SIZEMEM
    MOV DI,OFFSET KBDATA1
    MOV CL,ACTELN1
 
BACK:    
    MOV AL,[DI] 
    SUB AL,30H
    INC DI
    DEC CL
    JZ NEXT
    MOV AH,[DI] 
    SUB AH,30H
    
    ROR AL,4
    ADD AL,AH
    MOV [SI],AL 
    INC SI
    INC DI
    DEC CL
    JNZ BACK
NEXT:MOV [SI],AL

    MOV AX,0
    MOV SI,OFFSET SIZEMEM 
    MOV AL,[SI]
    
    
	MOV BL,AL    ;4-Move AL to BL	
	AND BL,0FH   ;5-Insert low digit in BL	
	MOV CL,4     ;6-Move 4 in CL for rotate
	AND AL,0F0H  ;7-Insert high digit in AL
	ROR AL,CL    ;8-Insert high digit in low
;			four bits of AL	
	MOV CL,0AH   ;9-Move 10 to CL
	MUL CL	     ;10-Multiply high digit
;			of number by 10
	ADD AL,BL    ;11-Calculate binary number 	
    
    
    
    MOV CL,AL
    MOV AX,20
    B11:
    ADD AX,20
    DEC CL
    JNZ B11

    
    MOV DI,OFFSET EPOINT
    MOV [DI],AX    
    ADD DI,2
    MOV [DI],DX                        
    
    
    
    LEA DX,MSG2
    MOV AH,09H
    INT 21H
    
    ;get string {
    MOV AH,0AH
    LEA DX,SIZEMEMORY
    INT 21H  
    
    MOV SI,OFFSET SPAGE
    MOV DI,OFFSET KBDATA1
    MOV CL,ACTELN1
    
BACK1:    
    MOV AL,[DI] 
    SUB AL,30H
    INC DI
    DEC CL
    JZ NEXT1
    MOV AH,[DI] 
    SUB AH,30H
    
    ROR AL,4
    ADD AL,AH
    MOV [SI],AL 
    INC SI
    INC DI
    DEC CL
    JNZ BACK1
NEXT1:MOV [SI],AL

    MOV AX,0
    MOV SI,OFFSET SPAGE 
    MOV AL,[SI]
    
    MOV CX,20
    MUL CX
    
    MOV DI,OFFSET PMEM
    MOV [DI],AX    
    ADD DI,2
   ; MOV [DI],DX  
    
    MOV AL,SIZEMEM
    
    MOV BL,AL    ;4-Move AL to BL	
	AND BL,0FH   ;5-Insert low digit in BL	
	MOV CL,4     ;6-Move 4 in CL for rotate
	AND AL,0F0H  ;7-Insert high digit in AL
	ROR AL,CL    ;8-Insert high digit in low
;			four bits of AL	
	MOV CL,0AH   ;9-Move 10 to CL
	MUL CL	     ;10-Multiply high digit
;			of number by 10
	ADD AL,BL    ;11-Calculate binary number 	
    
    MOV CL,SPAGE
    
    DIV CL
    CMP AH,00
    JZ FRONT1
    MOV AH,00
    ADD AL,1
    FRONT1:           
    MOV NUMPAGEMEM,AL
    MOV CL,2
    MUL CL
    ADD AX,STARTLM
    MOV ENDLM,AX  
    RET
SETSIZEMEMPAGE ENDP    
 
                  
DRAWMEMORY PROC NEAR  
    MOV AH,0h        ;7-Service 0 INT 10H
    MOV AL,12H      ;8-Mode 13, 320*200
    INT 10H
    MOV SI,OFFSET EPOINT   
       
    mov cx,20
    mov dx,20 
    mov bx,20
    loo: 
    mov dx,SPOINT
    mov cx,20 
    mov ax,0
    mov ah, 0ch
    mov al,2h
    int 10h
    inc dx 
    mov SPOINT,dx
    mov dx,20
    mov cx,bx
    inc cx
    int 10h
    mov bx,cx
    cmp cx,80
    jnz loo  
    mov dx,SPOINT
    mov cx,20 
looo:    mov ax,0
    mov ah, 0ch
    mov al,2h
    int 10h
    inc dx
    mov SPOINT,dx
    cmp dx,[SI]
    jnz looo 
    
    ;inja shekl kamel mishe:
    loo1: 
    mov dx,SPOINT
    mov cx,80 
    mov ax,0
    mov ah, 0ch
    mov al,2h
    int 10h
    dec dx 
    mov SPOINT,dx
    mov dx,[SI]
    mov cx,bx
    dec cx
    int 10h
    mov bx,cx
    cmp cx,20
    jnz loo1
    mov dx,SPOINT
    mov cx,80 
    looo1:    mov ax,0
    mov ah, 0ch
    mov al,2h
    int 10h
    dec dx
    mov SPOINT,dx
    cmp dx,20
    jnz looo1
     
    ; tike bandi shekl
    LEA DI,PMEM
    mov cx,20
    mov dx,20
    ADD DX,[DI] 
    mov bx,20
    loo2: 
    mov ah, 0ch
    mov al,2h
    int 10h
    inc cx 
    cmp cx,80 
    jnz loo2
    add dx,[DI] 
    mov cx,20
    cmp dx,[SI]
    jC loo2
    RET 
DRAWMEMORY ENDP     

SETPROGRAM PROC NEAR   
    RESTPROG:
    CALL CLRSCR
    
    LEA DX,MSGNPROG
    MOV AH,09H
    INT 21H       
    LEA DX,MSG3
    MOV AH,09H
    INT 21H
    
    MOV AH,0AH
    LEA DX,NAMEPROG
    INT 21H

    LEA DX,MSG4
    MOV AH,09H
    INT 21H
    
    MOV AH,0AH
    LEA DX,SIZEPROG 
    INT 21H 
    
    
    MOV SI,ENDLPR
    MOV DI,OFFSET NPKBDATA
    MOV CL,NPACTELN 
    
BACK2:    
    MOV AL,[DI] 
    INC DI
    MOV [SI],AL 
    INC SI
    DEC CL
    JNZ BACK2
    
    MOV ENDLPR,SI

 
    MOV SI, ENDLPR
    MOV DI,OFFSET SPKBDATA
    MOV CL,SPACTELN
    
BACK3:    
    MOV AL,[DI] 
    INC DI
    MOV [SI],AL 
    INC SI
    DEC CL
    JNZ BACK3
    
    MOV ENDLPR,SI
   ;-------------------------             
                
    MOV DI,OFFSET SPKBDATA
    MOV CL,SPACTELN
    MOV AL,[DI]
    SUB AL,30H
    INC DI
    DEC CL
    JZ NEXTT
    MOV AH,[DI]
    SUB AH,30H
    ROR AL,4
    ADD AL,AH
NEXTT: 

    MOV BL,AL    ;4-Move AL to BL	
	AND BL,0FH   ;5-Insert low digit in BL	
	MOV CL,4     ;6-Move 4 in CL for rotate
	AND AL,0F0H  ;7-Insert high digit in AL
	ROR AL,CL    ;8-Insert high digit in low
;			four bits of AL	
	MOV CL,0AH   ;9-Move 10 to CL
	MUL CL	     ;10-Multiply high digit
;			of number by 10
	ADD AL,BL    ;11-Calculate binary number 	
  
    MOV AH,0 
    MOV CX,0
    MOV CL,SPAGE
    DIV CL 
    
    CMP AH,00
    JZ FRONT
    ADD AL,1
    MOV AH,00 
    FRONT:
    
    MOV CX,AX
    
    LEA DI,NUMOFPAGEP
    SUB DI,2
    FINDPOS1:
    ADD DI,2
    CMP [DI],00
    JNE FINDPOS1
    MOV [DI],AX
    
    ADD AL,NUMPAGEVIRTU
    MOV NUMPAGEVIRTU,AL
    
    MOV DL,30H
    
    MOV SI,ENDLPA
    LEA DI,OFFSETPAGE
    SUB DI,2
    FINDPOS:
    ADD DI,2
    CMP [DI],00
    JNE FINDPOS
    MOV [DI],SI
    MOV DI,OFFSET NPKBDATA
    
        
    MOV AL,[DI]
    BACK4: 
    MOV [SI],AL 
    INC SI
    MOV [SI],DL
    INC DL
    INC SI
    DEC CX
    JNZ BACK4   
    
    MOV AL,NUMOFPROG
    ADD AX,1H
    MOV NUMOFPROG,AL
    
    
    MOV ENDLPA,SI
    LEA DX,MSG5     ;do you back main menu(N) or contine to input new porgram(Y)
    MOV AH,09H
    INT 21H
   
    MOV AH,7H
    INT 21H
    CMP AL,'Y'
    JE RESTPROG
    CMP AL,'y'
    JE RESTPROG
    RET
SETPROGRAM ENDP   

CLRSCR PROC NEAR 
     
   MOV AX,0600H    ;06 TO SCROLL & 00 FOR FULLJ SCREEN
    MOV BH,07H    ;ATTRIBUTE 7 FOR BACKGROUND AND 1 FOR FOREGROUND
    MOV CX,0000H    ;STARTING COORDINATES
    MOV DX,184FH    ;ENDING COORDINATES
    INT 10H        ;FOR VIDEO DISPLAY
    MOV AH,02H
    MOV DX,0000
    MOV BH,00
    INT 10H
    RET
    CLRSCR ENDP

;------------------text-drawing-----------------
PRINT PROC NEAR
        mov     dx,GC_INDEX
        mov     al,GC_SET_RESET
        out     dx,al
        inc     dx
        in      al,dx
        and     al,0f0h
        or      al,1            	;blue plane only set, others reset
        out     dx,al
        dec     dx
        mov     al,GC_ENABLE_SET_RESET
        out     dx,al
        inc     dx
        in      al,dx
        and     al,0f0h
        or      al,0fh          	;enable set/reset for all planes
        out     dx,al
        mov     dx,VGA_VIDEO_SEGMENT
        mov     es,dx           	;point to display memory
       
;
; Set driver to use the 8x14 font.
;
        mov     ah,11h  		;VGA BIOS character generator function,
        mov     al,30h  		; return info subfunction
        mov     bh,2    		;get 8x14 font pointer
        int     10h
        call    SelectFont
;
; Print the test string.
;
        mov     si,offset TestString
        mov     bx,TEST_TEXT_ROW
        mov     cx,TEST_TEXT_COL
        mov     ah,TEST_TEXT_COLOR
        call    DrawString       
PRINT   ENDP
  
  

DrawString      proc    near
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    bp
        push    ds

        mov     dx,GC_INDEX
        mov     al,GC_SET_RESET
        out     dx,al
        inc     dx
        in      al,dx
        and     al,0f0h
        and     ah,0fh
        or      al,ah
        out     dx,al

        mov     dx,GC_INDEX
        mov     al,GC_MODE
        out     dx,al
        inc     dx
        in      al,dx
        or      al,3
        out     dx,al
        mov     dx,VGA_VIDEO_SEGMENT
        mov     es,dx                   ;point to display memory
;
; Calculate screen address of byte character starts in.
;
        push    ds      		;point to BIOS data segment
        sub     dx,dx
        mov     ds,dx
        mov     di,ds:[SCREEN_WIDTH_IN_BYTES]   ;retrieve BIOS
                                                ; screen width
        pop     ds
        mov     ax,bx   		;row
        mul     di      		;calculate offset of start of row
        push    di      		;set aside screen width
        mov     di,cx   		;set aside the column
        and     cl,0111b 	;keep only the column in-byte address
        shr     di,1
        shr     di,1
        shr     di,1    		;divide column by 8 to make a byte address
        add     di,ax   		;and point to byte

        mov     dx,GC_INDEX
        mov     al,GC_ROTATE
        out     dx,al
        inc     dx
        in      al,dx
        and     al,0e0h
        or      al,cl
        out     dx,al
;
; Set up BH as bit mask for left half, BL as rotation for right half.
;
        mov     bx,0ffffh
        shr     bh,cl
        neg     cl
        add     cl,8
        shl     bl,cl
;

;
        pop     cx      		;get back screen width
        push    si
        push    di
        push    bx
;
; Set the bit mask for the left half of the character.
;
        mov     dx,GC_INDEX
        mov     al,GC_BIT_MASK
        mov     ah,bh
        out     dx,ax
LeftHalfLoop:
        lodsb
        and     al,al
        jz      LeftHalfLoopDone
        call    CharacterUp
        inc     di      		;point to next character location
        jmp     LeftHalfLoop
LeftHalfLoopDone:
        pop     bx
        pop     di
        pop     si
;
; Draw the right portion of each character in the string.
;
        inc     di      		;right portion of each character is across
                        		; byte boundary
;
; Set the bit mask for the right half of the character.
;
        mov     dx,GC_INDEX
        mov     al,GC_BIT_MASK
        mov     ah,bl
        out     dx,ax
RightHalfLoop:
        lodsb
        and     al,al
        jz      RightHalfLoopDone
        call    CharacterUp
        inc     di      		;point to next character location
        jmp     RightHalfLoop
RightHalfLoopDone:
;
        pop     ds
        pop     bp
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
DrawString      endp

CharacterUp     proc    near
        push    cx
        push    si
        push    di
        push    ds
;
; Set DS:SI to point to font and ES to point to display memory.
;
        lds     si,[FontPointer]        ;point to font
;
; Calculate font address of character.
;
        mov     bl,14   		;14 bytes per character
        mul     bl
        add     si,ax   		;offset in font segment of character

        mov     bp,FONT_CHARACTER_SIZE
        dec     cx      		; -1 because one byte per char
CharacterLoop:
        lodsb                   	;get character byte
        mov     ah,es:[di]      	;load latches
        stosb                   	;write character byte
;
; Point to next line of character in display memory.
;
        add     di,cx
;
        dec     bp
        jnz     CharacterLoop
;
        pop     ds
        pop     di
        pop     si
        pop     cx
        ret
CharacterUp     endp
;
; Set the pointer to the font to draw from to ES:BP.
;
SelectFont      proc    near
        mov     word ptr [FontPointer],bp       ;save pointer
        mov     word ptr [FontPointer+2],es
        ret
SelectFont      endp

;------------END---text-drawing--------------------------
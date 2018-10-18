; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
    assume DS:data ,SS:stack ,CS:code
start:
; set segment registers:
    mov ax, data
    mov ds, ax 
    
    mov si,1FFh
    mov di,3FFh
    mov cx,100
    mov bl,-1d
    mov [si+2h],12
BACK2:      
    inc bl
BACK1:
    mov ax,0
    dec cx 
    inc si
    inc di 
    mov ax,[si]
    sub ax,[di]
    cmp ax,0
    Ja BACK1
    cmp cx,0 
    ja BACK2
BACK3:  
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.

data segment
    char db '9'
ends

code segment
    assume DS:data ,SS:stack ,CS:code
start:   
    mov ax, data
    mov ds, ax   
    mov bl,char  
    
    mov cl,9            ; in khat ra ezafe kardam
    
    call fanc
    
    
fanc proc near
     mov ah,0eh
     mov al,bl
     int 10h
     dec bl
     dec cl              ; va hamintor in khat raham ezafe kardam
     cmp cl,0            ;in khat raham taghyir dadam
     jz back1
     call fanc
     
    back1:
    mov ax, 4c00h 
    int 21h    
ends

end start 
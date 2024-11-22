[org 0x0100]
jmp start

rand: dw 0
randnum: dw 0
oldisr : dd 0 
oldisr2 : dd 0 
score: db 'score: '
skipturn : dw 1
gameinfo : db 'Welcome to Catch Alphabets!                                                                                                                                "Catch, conquer, and claim your victory!"                                                                                                                        Test your reflexes and aim for the top!                                                                                                                    This is a thrilling game of catching alphabets where                                                                                                                             -speed                                                                          -accuracy                                                                       -a bit of luck                                                                                                                                                 MATTERS!',0
blinkingline: db 'PRESS ANY KEY OTHER THAN ESC TO PLAY !',0
finalscoreprompt: db 'GAME OVER!                                                                                                                                               YOUR FINAL SCORE WAS : ',0
finaltimeprompt: db 'YOUR FINAL TIME IS (in seconds) : ',0
ending: db '           Game Title: Catching Alphabets                                                                                                                                  Developed By: Muhammad Rahim & Ayesha Younus                                                                                                                    Game Credits:                                                                                                                                                   Development Team:                                                                                                                                                                                                                               - Lead Developer: Muhammad Rahim                                                                                                                                - Co-Developer: Ayesha Younus                                                                                                                                   - Game Logic Design: Muhammad Rahim & Ayesha Younus',0 
topleft: dw 0, 0
bottomright: dw 24, 79
tickcount:    dw   0 
seconds: dw 0


delay:
push bx
push cx
mov bx, 0xffff
mov cx, 0xffff

loop1:
dec bx
cmp bx, 0
jne loop1

loop2:
dec cx
cmp cx, 0
jne loop2

pop cx
pop bx
ret


; taking n as parameter, generate random number from 0 to n nad return in the stack
randG:
   push bp
   mov bp, sp
   pusha
   cmp word [rand], 0
   jne next

  MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
  INT     1AH
  inc word [rand]
  mov     [randnum], dx
  jmp next1

  next:
  mov     ax, 25173          ; LCG Multiplier
  mul     word  [randnum]     ; DX:AX = LCG multiplier * seed
  add     ax, 13849          ; Add LCG increment value
  ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
  mov     [randnum], ax          ; Update seed = return value

 next1:xor dx, dx
 mov ax, [randnum]
 mov cx, [bp+4]
 inc cx
 div cx
 
 mov [bp+6], dx
 popa
 pop bp
 ret 2

clrscr:       push es 
              push ax 
              push cx 
              push di 
              mov  ax, 0xb800 
              mov  es, ax             ; point es to video base 
              xor  di, di             ; point di to top left column 
              mov  ax, 0x0720         ; space char in normal attribute 
              mov  cx, 2000           ; number of screen locations 
              cld                     ; auto increment mode 
              rep  stosw              ; clear the whole screen 
              pop  di 
              pop  cx 
              pop  ax 
              pop  es 
              ret 

displaycredits:
              pusha
              push ds
              pop es
              mov di,ending
              mov cx,0xffff
              mov al,0
              repne scasb             
              mov  ax, 0xffff          
              sub  ax, cx             
              dec  ax 
              mov  cx, ax 
              mov si,ending
              push 0xb800
              pop es
              mov di,160
              cld                     ; auto increment mode 
nextcharacter:     lodsb                   ; load next char in al 
              mov ah,0x07
              stosw                   ; print char/attribute pair 
              loop nextcharacter
              mov ax,dx
              popa
              ret

finalscoredisplay:
              pusha
              push ds
              pop es
              mov di,finalscoreprompt
              mov cx,0xffff
              mov al,0
              repne scasb             
              mov  ax, 0xffff          
              sub  ax, cx             
              dec  ax 
              mov  cx, ax 
              mov si,finalscoreprompt
              push 0xb800
              pop es
              mov di,1662
              cld                     ; auto increment mode 
nextchar:     lodsb                   ; load next char in al 
              mov ah,0x07
              stosw                   ; print char/attribute pair 
              loop nextchar
              mov ax,dx
              call naam
finaltimedisplay:
              push ds
              pop es
              mov di,finaltimeprompt
              mov cx,0xffff
              mov al,0
              repne scasb             
              mov  ax, 0xffff          
              sub  ax, cx             
              dec  ax 
              mov  cx, ax 
              mov si,finaltimeprompt
              push 0xb800
              pop es
              mov di,2278
              cld                     ; auto increment mode 
nextchar2:    lodsb                   ; load next char in al 
              mov ah,0x07
              stosw                   ; print char/attribute pair 
              loop nextchar2
              mov ax,[seconds]
              call naam
              popa
              ret
 
naam:
              mov  bx, 10             ; use base 10 for division 
              mov  cx, 0              ; initialize count of digits 
nextdigit:    mov  dx, 0              ; zero upper half of dividend 
              div  bx                 ; divide by 10 
              add  dl, 0x30           ; convert digit into ascii value 
              push dx                 ; save ascii value on stack 
              inc  cx                 ; increment count of values  
              cmp  ax, 0              ; is the quotient zero 
              jnz  nextdigit             ; 
              nextpos:      pop  dx                 ; remove a digit from the stack 
              mov  dh, 0x07           ; use normal attribute 
              mov [es:di], dx         ; print char on screen 
              add  di, 2              ; move to next screen location 
              loop nextpos   
              ret

sleep:
    push cx
    mov cx, 0xFFFF

delay2: 
    loop delay2
    pop cx
    ret


printrectangle:
    push bp
    mov bp,sp
    pusha
    mov ax,0xb800
    mov es,ax
    mov ax,[bp+10]
    mov bx,160
    mul bx
    add ax,[bp+8]
    mov cx,[bp+4]
    sub cx,[bp+8]
    mov di,ax
Top:
    call sleep
    mov ax,0x4020
    mov word [es:di],ax
    add di,2
    loop Top
    mov cx,[bp+6]
    sub cx,[bp+10]
Right:
    call sleep
    mov ax,0x4020
    mov word [es:di],ax
    add di,160
    loop Right
    mov cx,[bp+4]
    sub cx,[bp+8]
Bottom:
    call sleep
    mov ax,0x4020
    mov word [es:di],ax
    sub di,2
    loop Bottom
    mov cx,[bp+6]
    sub cx,[bp+10]    
Left:
    call sleep
    mov ax,0x4020
    mov word [es:di],ax
    sub di,160
    loop Left
    popa
    pop bp
    ret 8
    
printrectangle2:
    push bp
    mov bp,sp
    pusha
    mov ax,0xb800
    mov es,ax
    mov ax,[bp+10]
    mov bx,160
    mul bx
    add ax,[bp+8]
    mov cx,[bp+4]
    sub cx,[bp+8]
    mov di,ax
Top2:
    mov ax,0x4020
    mov word [es:di],ax
    add di,2
    loop Top2
    mov cx,[bp+6]
    sub cx,[bp+10]
Right2:
    mov ax,0x4020
    mov word [es:di],ax
    add di,160
    loop Right2
    mov cx,[bp+4]
    sub cx,[bp+8]
Bottom2:
    mov ax,0x4020
    mov word [es:di],ax
    sub di,2
    loop Bottom2
    mov cx,[bp+6]
    sub cx,[bp+10]    
Left2:
    mov ax,0x4020
    mov word [es:di],ax
    sub di,160
    loop Left2
    popa
    pop bp
    ret 8

printrandomalphabets:
                pusha
                mov ax,0xb800
                mov es,ax
                mov cx,0
randomlabel1:
                cmp cx,50
                je exitrandomlabel1
                add cx,1
                sub sp,2
                push 25
                call randG
                pop dx
                mov ax,0x8041
                add ax,dx
                sub sp, 2
                push 15
                call randG
                pop dx
                add ah,dl
                sub sp, 2
                push 2000
                call randG
                pop dx
                shl dx,1
                mov di,dx
                mov word [es:di],ax
                jmp randomlabel1
exitrandomlabel1:
                popa
                ret

printinfo:
              pusha
              push ds
              pop es
              mov di,gameinfo
              mov cx,0xffff
              mov al,0
              repne scasb             
              mov  ax, 0xffff          
              sub  ax, cx             
              dec  ax 
              mov  cx, ax 
              mov si,gameinfo
              push 0xb800
              pop es
              mov di,1010
              cld                     ; auto increment mode 
nextcharacter1:lodsb                   ; load next char in al 
              mov ah,0x07
              stosw                   ; print char/attribute pair 
              loop nextcharacter1
              mov ax,dx
              popa
              ret

blink:        
              pusha
              push ds
              pop es
              mov di,blinkingline
              mov cx,0xffff
              mov al,0
              repne scasb             
              mov  ax, 0xffff          
              sub  ax, cx             
              dec  ax 
              mov  cx, ax 
              mov si,blinkingline
              push 0xb800
              pop es
              mov di,3560
              cld                     ; auto increment mode 
nextcharacter2:lodsb                   ; load next char in al 
              mov ah,0x87
              stosw                   ; print char/attribute pair 
              loop nextcharacter2
              mov ax,dx
              popa
              ret

startscreen:
      push word [topleft]
      push word [topleft + 2]
      push word [bottomright]
      push word [bottomright + 2]
      call printrectangle
      call printrandomalphabets
      call printinfo
      call blink
      push word [topleft]
      push word [topleft + 2]
      push word [bottomright]
      push word [bottomright + 2]
      call printrectangle2
      ret


printscore:
pusha
mov di, 120
mov si, score
mov cx, 6
mov ax,0
kuchbhilabel:
lodsb
mov ah, 0x05
stosw 
loop kuchbhilabel
mov  ax, [bp+12] 
call naam
popa
ret     

printbucket:
    push 0xb800
    pop es
    mov di,3914
    mov ax,0x06dc
    mov[es:di],ax
    add di,2
    mov[es:di],ax
    sub di,160
    mov[es:di],ax
    sub di,4
    mov[es:di],ax
    add di,160
    mov[es:di],ax
    ret


generatenew:
cmp cx,5
je stopgenerating
add cx,1
sub sp,2
push 25
call randG
pop dx
mov ax,0x0041
add ax,dx
sub sp, 2
push 15
call randG
pop dx
add ah,dl
sub sp, 2
push 79
call randG
pop dx
shl dx,1
mov di,dx
mov dx,[es:di]
cmp dx,0x0720
je l2
add di,160
l2:
mov word [bp],di
mov word [es:di],ax
sub bp,2
jmp generatenew

stopgenerating:
pop di
ret 

generatealphabet:
push di
cmp cx,5
je stopgenerating
add bp,10
cmp cx,0
je generatenew
regengerate:
push bp
add bp,2
recheck:
sub bp,2
cmp word [bp],0
jne recheck
add cx,1
sub sp,2
push 25
call randG
pop dx
mov ax,0x0041
add ax,dx
sub sp, 2
push 14
call randG
pop dx
cmp dl,0x07
jne skipper
add dl,1
skipper:
add ah,dl
sub sp, 2
push 79
call randG
pop dx
shl dx,1
mov di,dx
mov dx,[es:di]
cmp dx,0x0720
je l4
add di,160
l4:
mov word [bp],di
mov word [es:di],ax
cmp cx,5
jne recheck
pop bp
sub bp,10
jmp stopgenerating

movedown:
push dx
push cx
push ax
push bx
xor word [skipturn],0x0001
add bp,10
mov dx,0
mov ax,0
mov cx,0

firstalpabet:mov di,[bp]
mov si,di
add si,160
mov ax,[es:di]
mov word [es:di],0x0720
mov bx,[es:si]
cmp bx,0x06dc
je skip1catch
cmp si,3838
jge skip1
mov [es:si],ax
mov [bp],si
jmp secondalphabet

skip1catch:inc cx
skip1:inc dx
mov word [bp],0

secondalphabet:sub bp,2
mov di,[bp]
mov si,di
mov bx,[skipturn]
cmp bx,0
je skippingturn1
add si,160
skippingturn1:
mov ax,[es:di]
mov word [es:di],0x0720
mov bx,[es:si]
cmp bx,0x06dc
je skip2catch
cmp si,3838
jge skip2
mov [es:si],ax
mov word [bp],si
jmp thirdalphabet

skip2catch:inc cx
skip2:inc dx
mov word [bp],0

thirdalphabet:sub bp,2
mov di,[bp]
mov si,di
add si,320
mov ax,[es:di]
mov word [es:di],0x0720
mov bx,[es:si]
cmp bx,0x06dc
je skip3catch
cmp si,3838
jge skip3
mov [es:si],ax
mov word [bp],si
jmp fourthalphabet

skip3catch: inc cx
skip3:inc dx
mov word [bp],0

fourthalphabet:sub bp,2
mov di,[bp]
mov si,di
mov bx,[skipturn]
cmp bx,0
je skippingturn2
add si,480
skippingturn2:
mov ax,[es:di]
mov word [es:di],0x0720
mov bx,[es:si]
cmp bx,0x06dc
je skip4catch
cmp si,3838
jge skip4
mov [es:si],ax
mov word [bp],si
jmp fifthalphabet

skip4catch:inc cx
skip4:inc dx
mov word [bp],0

fifthalphabet:sub bp,2
mov di,[bp]
mov si,di
mov bx,[skipturn]
cmp bx,0
je skippingturn3
add si,160
jmp skippingturn4
skippingturn3:
add si,320
skippingturn4:
mov ax,[es:di]
mov word [es:di],0x0720
mov bx,[es:si]
cmp bx,0x06dc
je skip5catch
cmp si,3838
jge skip5
mov [es:si],ax
mov word [bp],si
jmp stopmoving

skip5catch: inc cx
skip5:inc dx
mov word [bp],0

stopmoving:
sub bp,2
pop bx
pop ax
add [bp+12],cx
mov bx,cx
pop cx
sub cx,dx
sub dx,bx
add [bp+14],dx
pop dx
ret


playgame:
 push bp
 mov bp,sp
 call printbucket
 mov di,3914
 mov ax,0xb800
 mov es,ax
 mov cx,0
 push cx
 push cx
 sub sp,10
 push bp
 mov bp,sp


l3:
cli
push di
call generatealphabet
call movedown
call printscore
pop di
sti
mov bx,[bp+14]
cmp bx,10
jge l1
mov bx,[seconds]
call delay
call delay
cmp bx,40
jg meet
call delay
cmp bx,20
jg meet
call delay



meet:
jmp l3
    
l1: 
    mov bx,[bp+12]
    pop bp
    mov word [bp+4],bx
    add sp,14
    pop bp
    ret

; keyboard interrupt service routine 
kbisr:        push ax 
              push es 
              mov ax,0xb800
              mov es,ax
              in al,0x60 ; call BIOS keyboard service
 cmp al,0x4b
 je left
 cmp al,0x4d
 je right
 jmp exit
 left:
 mov ax,di
 mov si,di
 sub ax,2
 cmp ax,3840
 jne existleft
 add ax,2
 add si,2
existleft: mov di,ax
 mov word [es:si],' '
 add si,2
    mov word [es:si],' '
    sub si,160
    mov word [es:si],' '
    sub si,4
    mov word [es:si],' '
    add si,160
    mov word [es:si],' '
 mov ax,0x06dc
    mov[es:di],ax
    add di,2
    mov[es:di],ax
    sub di,160
    mov[es:di],ax
    sub di,4
    mov[es:di],ax
    add di,160
    mov[es:di],ax
    add di,2
 jmp exit
 right:
 mov ax,di
 mov si,di
 add ax,2
 cmp ax,3998
 jne existright
 sub ax,2
 sub si,2
existright: mov di,ax
    mov word [es:si],' '
    add si,2
    mov word [es:si],' '
    sub si,160
    mov word [es:si],' '
    sub si,4
    mov word [es:si],' '
    add si,160
    mov word [es:si],' '
    mov ax,0x06dc
    mov[es:di],ax
    add di,2
    mov[es:di],ax
    sub di,160
    mov[es:di],ax
    sub di,4
    mov[es:di],ax
    add di,160
    mov[es:di],ax
    add di,2
exit:         
              pop es
              pop ax 
              jmp far [cs:oldisr]    ; call the original ISR

timer:  push ax 
        push bx
        push es
        mov ax,0xb800
        mov es,ax
        
        inc word [cs:tickcount]; increment tick count 
        mov ax,[cs:tickcount]
        cmp ax,19
        jne exit2
        inc word [cs:seconds]
        mov ax,0
        mov [cs:tickcount],ax
exit2:  pop es
        pop bx
        pop ax
        jmp far [cs:oldisr2]


scrolldown:   push bp 
              mov  bp,sp 
              push ax 
              push cx 
              push si   
              push di 
              push es 
              push ds 
 
              mov  ax, 80             ; load chars per row in ax 
              mul  byte [bp+4]        ; calculate source position 
              push ax                 ; save position for later use 
              shl  ax, 1              ; convert to byte offset 
              mov  si, 3998           ; last location on the screen 
              sub  si, ax             ; load source position in si 
              mov  cx, 2000           ; number of screen locations 
              sub  cx, ax             ; count of words to move 
              mov  ax, 0xb800 
              mov  es, ax             ; point es to video base 
              mov  ds, ax             ; point ds to video base 
              mov  di, 3998           ; point di to lower right column 
              std                     ; set auto decrement mode 
              rep  movsw              ; scroll up 
              mov  ax, 0x0720         ; space in normal attribute 
              pop  cx                 ; count of positions to clear 
              rep  stosw              ; clear the scrolled space 
 
              pop  ds 
              pop  es 
              pop  di 
              pop  si 
              pop  cx 
              pop  ax 
              pop  bp 
              ret  2 

start:call clrscr
call startscreen
mov ah, 0 ; service 0 – get keystroke
int 0x16 ; call BIOS keyboard service
cmp al,1bh
je escapeend1
call clrscr
              xor  ax, ax 
              mov  es, ax             ; point es to IVT base 
              mov  ax, [es:9*4] 
              mov  [oldisr], ax       ; save offset of old routine 
              mov  ax, [es:9*4+2] 
              mov  [oldisr+2], ax     ; save segment of old routine 
              mov  ax, [es:8*4] 
              mov  [oldisr2], ax       ; save offset of old routine 
              mov  ax, [es:8*4+2] 
              mov  [oldisr2+2], ax     ; save segment of old routine 
              cli                     ; disable interrupts 
              mov  word [es:9*4], kbisr ; store offset at n*4 
              mov  [es:9*4+2], cs     ; store segment at n*4+2 
              mov  word [es:8*4], timer ; store offset at n*4 
              mov  [es:8*4+2], cs     ; store segment at n*4+2 
              sti  
              push ds
              push es
              sub sp,2
call playgame
pop dx
pop es
pop ds
jmp skipaline
escapeend1: jmp escapeend
skipaline:
              mov ax, [oldisr2]        ; read old offset in ax 
              mov bx, [oldisr2+2]      ; read old segment in bx 
              cli                     ; disable interrupts 
              mov [es:8*4], ax        ; restore old offset from ax 
              mov [es:8*4+2], bx      ; restore old segment from bx 
              sti   ; store segment at n*4+2 
              mov ax, [oldisr]        ; read old offset in ax 
              mov bx, [oldisr+2]      ; read old segment in bx 
              cli                     ; disable interrupts 
              mov [es:9*4], ax        ; restore old offset from ax 
              mov [es:9*4+2], bx      ; restore old segment from bx 
              sti   ; store segment at n*4+2 
escapeend:
call clrscr
call finalscoredisplay
push word [topleft]
push word [topleft + 2]
push word [bottomright]
push word [bottomright + 2]
call printrectangle
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
;temp:mov ah, 0 ; service 0 – get keystroke
;int 0x16 ; call BIOS keyboard service
;cmp al,1bh
;jne temp
call clrscr
call displaycredits
call delay
call delay
call delay
call delay
mov ax,1
mov cx,25
repscroll:
call delay
call delay
push ax
call scrolldown
loop  repscroll
end:mov ax, 0x4c00
int 21h
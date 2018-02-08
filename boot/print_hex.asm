print_hex:

  mov bx, HEX_OUT
  add bx, 2             ; skip the 0x prefix
  mov cl, 12

  print_hex_loop:
    mov ax, dx
    shr ax, cl            ; shift ax to the right by cl to grab first part of hex number first
    and ax, 0x000f        ; only keep first 4 bits

    cmp ax, 10
    jl less_than_ten
    cmp ax, 10
    je ten
    cmp ax, 11
    je eleven
    cmp ax, 12
    je twelve
    cmp ax, 13
    je thirteen
    cmp ax, 14
    je fourteen
    cmp ax, 15
    je fifteen

    ten:
      mov [bx], byte 'a'
      jmp print_hex_step
    eleven:
      mov [bx], byte 'b'
      jmp print_hex_step
    twelve:
      mov [bx], byte 'c'
      jmp print_hex_step
    thirteen:
      mov [bx], byte 'd'
      jmp print_hex_step
    fourteen:
      mov [bx], byte 'e'
      jmp print_hex_step
    fifteen:
      mov [bx], byte 'f'
      jmp print_hex_step

    less_than_ten:
      add al, 48          ; add ASCII offset of 48 (ascii number for 'a')
      mov [bx], al

    print_hex_step:
      add bx, 1
      sub cl, 4
      cmp cl, 0
      jge print_hex_loop

  mov bx, HEX_OUT
  call print_string
  ret

HEX_OUT: db '0x0000', 0

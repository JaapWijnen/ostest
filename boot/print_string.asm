print_string:
  mov ah, 0x0e

print_string_loop:
  mov al, [bx]
  cmp al, 0
  je end
  int 0x10
  add bx, 0x01
  jmp print_string_loop

end:
  ret

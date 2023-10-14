[BITS 16]
[ORG 0x7C00]

start:
    cli               ; Disable interrupts
    lgdt [gdt_desc]   ; Load GDT descriptor

    ; Enable protected mode
    mov eax, cr0
    or al, 1
    mov cr0, eax

    ; Far jump to reload CS
    jmp 0x08:protected_mode_start

; GDT
gdt_null:
    dd 0x0
    dd 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 0x9A
    db 0xCF
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 0x92
    db 0xCF
    db 0x0
gdt_end:

gdt_desc:
    dw gdt_end - gdt_null - 1
    dd gdt_null

[BITS 32]
protected_mode_start:
    ; Setup data segments
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Initialize stack pointer
    mov esp, 0x9C00
    ; Clear screen
    mov edi, 0xB8000      ; Start address of text video memory
    mov ecx, 2000         ; 80 columns x 25 rows
    mov ax, 0x0720        ; Space with attribute byte
clear_loop:
    mov [edi], ax
    add edi, 2
    loop clear_loop

    ; Print 'B'
    mov dword [0xB8000], 0x0442
    mov dword [0xB8002], 0x0442
    mov dword [0xB8004], 0x0442
    mov dword [0xB8006], 0x0442
    mov dword [0xB80B0], 0x0442
    ;mov dword [0xB8020], 0x044A
    ;mov dword [0xB8021], 0x044B

    ; Hang
    cli
    hlt

times 510-($-$$) db 0
dw 0xAA55
; A = J
; B = K
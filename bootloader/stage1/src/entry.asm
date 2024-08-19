; ------------------------------------------------------------------
; Header

[bits 16]
%ifidn __OUTPUT_FORMAT__, bin 
[org 0x7c00]
%endif

; ------------------------------------------------------------------
; Code

mov [BootDrive], dl
mov ax, 0           ; can't set ds/es directly
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00              ; stack grows downwards from where we are loaded in memory

; some BIOSes might start us at 07C0:0000 instead of 0000:7C00, make sure we are in the
; expected location
push es
push word .after
retf
.after:
mov bp, 0x9000
mov sp, bp

call load_stage2
jmp switch_to_pm

; ------------------------------------------------------------------
; Includes

%include "disk.asm"
%include "load_stage2.asm"
%include "gdt.asm"
%include "protected_mode.asm"

; ------------------------------------------------------------------
; Variables

BootDrive: db 0

; ------------------------------------------------------------------
; Footer

times 510-($-$$) db 0
dw 0xaa55
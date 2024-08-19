[bits 16]
switch_to_pm:
	cli

	lgdt [gdt_descriptor]

	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	jmp CodeSeg:init_protected_mode

[bits 32]

init_protected_mode:
	mov ax, DataSeg
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax

	mov ebp, 0x90000
	mov esp, ebp

	jmp begin_protected_mode

begin_protected_mode:	
	jmp BootloaderOffset
	
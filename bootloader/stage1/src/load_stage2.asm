[bits 16]
load_stage2:
	mov bx,BootloaderOffset
	mov dh,40
	mov dl, [BootDrive]
	call disk_load
	ret

BootloaderOffset equ 0x1000
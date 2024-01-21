TARGET=BOOTX64.EFI

include uefi/Makefile

vm: $(TARGET)
	dd if=/dev/zero of=fat.img bs=1k count=1440
	mformat -i fat.img -f 1440
	mmd -i fat.img ::/EFI
	mmd -i fat.img ::/EFI/BOOT
	mcopy -i fat.img $(TARGET) ::/EFI/BOOT
	mkgpt -o hdimage.bin --image-size 4096 --part fat.img --type system
	qemu-system-x86_64 -drive file=hdimage.bin,format=raw -bios /usr/share/edk2-ovmf/x64/OVMF.fd

vmclean: clean
	rm fat.img || true
	rm hdimage.bin || true



@rem assemble our files
    @echo off
    cd src
    @echo on
    nasm boot_sector.asm -f bin -o ../bin/boot_sector.bin
    nasm adventure.asm -f bin -o ../bin/adventure.bin
    nasm boot_pm.asm -f bin -o ../bin/image.bin
    @echo off
    cd ..
    @echo on

@rem moosh them together into one binary
    @echo off
    cd bin
    @echo on
    cat boot_sector.bin adventure.bin > image.bin
    @echo off
    cd ..
    @echo on

@rem prepare
    @echo off
    echo Checking that dir 'bin' exists...
    if not exist "bin" mkdir "bin"


@rem assemble our files
    echo Assembling files...
    cd src
    @echo on
    nasm boot_sector.asm -f bin -o ../bin/boot_sector.bin
    nasm adventure.asm -f bin -o ../bin/adventure.bin
    nasm boot_pm.asm -f bin -o ../bin/image.bin
    @echo off
    cd ..

@rem moosh them together into one binary
    echo Mooshing binary objects together...
    cd bin
    @echo on
    cat boot_sector.bin adventure.bin > image.bin
    @echo off
    cd ..
    @echo on

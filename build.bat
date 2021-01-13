@echo off

@rem
    echo Checking that dir 'bin' exists...
    if not exist "bin" mkdir "bin"

@rem
    echo Assembling files...
    cd src
    @echo on
    nasm boot_sector.asm -f bin -o ../bin/boot_sector.bin
    nasm adventure.asm -f bin -o ../bin/adventure.bin
    @echo off
    cd ..

@rem
    echo Mooshing binary objects together...
    cd bin
    @echo on
    cat boot_sector.bin adventure.bin > image.bin
    @echo off
    cd ..
    @echo on

echo Ensuring that dir 'bin' exists
mkdir -p ./bin/

echo Assembling files
cd src
nasm boot_sector.asm -f bin -o ../bin/boot_sector.bin
nasm adventure.asm -f bin -o ../bin/adventure.bin
cd ..

echo Mooshing binary objects together...
cd bin
cat boot_sector.bin adventure.bin > image.bin
cd ..


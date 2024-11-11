from PIL import Image

img = Image.open("arrow.png")

for y in range(img.height):
    print('    .byte %', end='')
    for x in range(0,8):
        print('1' if img.getpixel((x, y))[3] > 0x20 else '0', end='')
    print(', %', end='')
    for x in range(8,16):
        print('1' if img.getpixel((x, y))[3] > 0x20 else '0', end='')
    print(', %', end='')
    for x in range(16,24):
        print('1' if img.getpixel((x, y))[3] > 0x20 else '0', end='')
    print()
print('    .byte 0')
print()

for y in range(img.height, 0, -1):
    print('    .byte %', end='')
    for x in range(0,8):
        print('1' if img.getpixel((x, y-1))[3] > 0x20 else '0', end='')
    print(', %', end='')
    for x in range(8,16):
        print('1' if img.getpixel((x, y-1))[3] > 0x20 else '0', end='')
    print(', %', end='')
    for x in range(16,24):
        print('1' if img.getpixel((x, y-1))[3] > 0x20 else '0', end='')
    print()
print('    .byte 0')
print()

for y in range(img.height):
    print('    .byte %', end='')
    for x in range(23,15,-1):
        print('1' if img.getpixel((x, y))[3] > 0x20 else '0', end='')
    print(', %', end='')
    for x in range(15,7,-1):
        print('1' if img.getpixel((x, y))[3] > 0x20 else '0', end='')
    print(', %', end='')
    for x in range(7,-1,-1):
        print('1' if img.getpixel((x, y))[3] > 0x20 else '0', end='')
    print()
print('    .byte 0')
print()

for y in range(img.height, 0, -1):
    print('    .byte %', end='')
    for x in range(23,15,-1):
        print('1' if img.getpixel((x, y-1))[3] > 0x20 else '0', end='')
    print(', %', end='')
    for x in range(15,7,-1):
        print('1' if img.getpixel((x, y-1))[3] > 0x20 else '0', end='')
    print(', %', end='')
    for x in range(7,-1,-1):
        print('1' if img.getpixel((x, y-1))[3] > 0x20 else '0', end='')
    print()
print('    .byte 0')
print()

feet = Image.open("feet.png")
for y in range(feet.height):
    print('    .byte %', end='')
    for x in range(0,8):
        print('1' if feet.getpixel((x, y))[3] > 0x20 else '0', end='')
    print(', %', end='')
    for x in range(8,16):
        print('1' if feet.getpixel((x, y))[3] > 0x20 else '0', end='')
    print(', %', end='')
    for x in range(16,21):
        print('1' if feet.getpixel((x, y))[3] > 0x20 else '0', end='')
    print()
print('    .byte 0')
print()


-- Gumnut
text
org 0x00 -- Start on reset
jmp main

-- Data memory layout
Data
leds:           bss 1
display:        bss 1
pushbtn:        bss 1
switches:       bss 1
contador:       byte 0

-- Main program
text
org 0x010
main:           ldm r1, contador
continue:       out r1, display
inp r2, switches
again:          inp r3, pushbtn
and r3, r3, 1
bnz again
add r1, r1, 1
subt r0, r1, r2
bnz continue
add r1, r0, 0
jmp continue

delay:          add r7, r0, 0
again3:         add r6, r0, 0
again2:         add r5, r0, 0
again1:         add r5, r0, 1
sub r0, r5, 0xFF
bnz again1
add r6. r6. 1
sub r0, r6, 0xFF
bnz again2
add r7, r7, 1
sub r0, r7, 0x0C
bnz again3
ret 



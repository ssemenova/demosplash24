.segment "SPRITES"
.org $2000
sprite_data:
    .res 1024
.reloc
.segment "CODE"

reg_color_sp0 := $d027
reg_color_sp1 := $d028
reg_color_sp2 := $d029
reg_color_sp3 := $d02a
reg_color_sp4 := $d02b
reg_color_sp5 := $d02c
reg_color_sp6 := $d02d
reg_color_sp7 := $d02e

color_black = $0
color_white = $1
color_red   = $2
color_cyan  = $3
color_purple = $4
color_green = $5
color_blue = $6
color_yellow = $7
color_orange = $8
color_brown = $9
color_pink = $a
color_darkgray = $b
color_lightgray = $c
color_lightgreen = $d
color_lightblue = $e

sprite_pointer       = sprite_data / 64
.export _init_sprites
_init_sprites:
    ;====================
    ; Copy Data
    ;====================

    ldy #0
sprite_copy_loop:
    lda arrow_bin+64*0,y
    sta sprite_data+64*0,y
    lda arrow_bin+64*4,y
    sta sprite_data+64*4,y
    lda arrow_bin+64*8,y
    sta sprite_data+64*8,y
    iny
    bne sprite_copy_loop

    ;====================
    ; Initialize Memory
    ;====================

    lda #sprite_pointer+0
    sta $0400 + $3f8
    lda #sprite_pointer+1
    sta $0400 + $3f9
    lda #sprite_pointer+2
    sta $0400 + $3fa
    lda #sprite_pointer+3
    sta $0400 + $3fb

    ;============================
    ; Initialize VIC-II registers
    ;============================

    lda #$00   ; enable Sprites
    sta $d015
    lda #$00   ; set single color mode for Sprite#0
    sta $d01c
    lda #$00   ; Sprite#0 has priority over background
    sta $d01b
    lda #$ff   ; Sprite#0 and #1 stretch
    sta $d01d
    sta $d017

    lda #color_black
    sta $d021

    lda #color_red
    sta reg_color_sp0
    lda #color_lightblue
    sta reg_color_sp2
    lda #color_white
    sta reg_color_sp1
    sta reg_color_sp3

    lda #$00    ; set X-Coord high bit (9th Bit)
    sta $d010

    lda #$60    ; set Sprite#0 positions with X/Y coords to
    sta $d000   ; $d000 corresponds to X-Coord
    sta $d002
    lda #$90
    sta $d004
    sta $d006

    lda #$b0
    sta $d001   ; $d001 corresponds to Y-Coord
    sta $d005   ; $d001 corresponds to Y-Coord
    lda #64
    sta $d003   ; $d001 corresponds to Y-Coord
    sta $d007   ; $d001 corresponds to Y-Coord

    rts 





arrow_bin:
arrow_upleft:
    .byte %01111111, %11111111, %00000000
    .byte %10000000, %00000000, %10000000
    .byte %10000000, %00000001, %10000000
    .byte %10011111, %11110011, %00000000
    .byte %10011111, %11100110, %00000000
    .byte %10011111, %11001100, %00000000
    .byte %10011100, %00001000, %00000000
    .byte %10011100, %00000100, %00000000
    .byte %10011100, %11110110, %00000000
    .byte %10011100, %11111011, %00000000
    .byte %10011000, %11000001, %10000000
    .byte %10010000, %11000000, %11000000
    .byte %10000110, %01001111, %01100000
    .byte %10001011, %00001111, %10110000
    .byte %10011001, %10001100, %00001000
    .byte %10110000, %11001100, %01111000
    .byte %01100000, %01100100, %11000000
    .byte %00000000, %00110001, %10000000
    .byte %00000000, %00011001, %00000000
    .byte %00000000, %00001101, %00000000
    .byte %00000000, %00000011, %00000000
    .byte 0

filled_upleft:
    .byte %01111111, %11111111, %00000000
    .byte %11111111, %11111111, %10000000
    .byte %11111111, %11111111, %10000000
    .byte %11111111, %11111111, %00000000
    .byte %11111111, %11111110, %00000000
    .byte %11111111, %11111100, %00000000
    .byte %11111111, %11111000, %00000000
    .byte %11111111, %11111100, %00000000
    .byte %11111111, %11111110, %00000000
    .byte %11111111, %11111111, %00000000
    .byte %11111111, %11111111, %10000000
    .byte %11111111, %11111111, %11000000
    .byte %11111111, %11111111, %11100000
    .byte %11111011, %11111111, %11110000
    .byte %11111001, %11111111, %11111000
    .byte %11110000, %11111111, %11111000
    .byte %01100000, %01111111, %11000000
    .byte %00000000, %00111111, %10000000
    .byte %00000000, %00011111, %00000000
    .byte %00000000, %00001111, %00000000
    .byte %00000000, %00000011, %00000000
    .byte 0
arrow_downleft:
    .byte %00000000, %00000011, %00000000
    .byte %00000000, %00001101, %00000000
    .byte %00000000, %00011001, %00000000
    .byte %00000000, %00110001, %10000000
    .byte %01100000, %01100100, %11000000
    .byte %10110000, %11001100, %01111000
    .byte %10011001, %10001100, %00001000
    .byte %10001011, %00001111, %10110000
    .byte %10000110, %01001111, %01100000
    .byte %10010000, %11000000, %11000000
    .byte %10011000, %11000001, %10000000
    .byte %10011100, %11111011, %00000000
    .byte %10011100, %11110110, %00000000
    .byte %10011100, %00000100, %00000000
    .byte %10011100, %00001000, %00000000
    .byte %10011111, %11001100, %00000000
    .byte %10011111, %11100110, %00000000
    .byte %10011111, %11110011, %00000000
    .byte %10000000, %00000001, %10000000
    .byte %10000000, %00000000, %10000000
    .byte %01111111, %11111111, %00000000
    .byte 0

    .byte %00000000, %00000011, %00000000
    .byte %00000000, %00001111, %00000000
    .byte %00000000, %00011111, %00000000
    .byte %00000000, %00111111, %10000000
    .byte %01100000, %01111111, %11000000
    .byte %11110000, %11111111, %11111000
    .byte %11111001, %11111111, %11111000
    .byte %11111011, %11111111, %11110000
    .byte %11111111, %11111111, %11100000
    .byte %11111111, %11111111, %11000000
    .byte %11111111, %11111111, %10000000
    .byte %11111111, %11111111, %00000000
    .byte %11111111, %11111110, %00000000
    .byte %11111111, %11111100, %00000000
    .byte %11111111, %11111000, %00000000
    .byte %11111111, %11111100, %00000000
    .byte %11111111, %11111110, %00000000
    .byte %11111111, %11111111, %00000000
    .byte %11111111, %11111111, %10000000
    .byte %11111111, %11111111, %10000000
    .byte %01111111, %11111111, %00000000
    .byte 0


    .byte %00000000, %11111111, %11111110
    .byte %00000001, %00000000, %00000001
    .byte %00000001, %10000000, %00000001
    .byte %00000000, %11001111, %11111001
    .byte %00000000, %01100111, %11111001
    .byte %00000000, %00110011, %11111001
    .byte %00000000, %00010000, %00111001
    .byte %00000000, %00100000, %00111001
    .byte %00000000, %01101111, %00111001
    .byte %00000000, %11011111, %00111001
    .byte %00000001, %10000011, %00011001
    .byte %00000011, %00000011, %00001001
    .byte %00000110, %11110010, %01100001
    .byte %00001101, %11110000, %11010001
    .byte %00010000, %00110001, %10011001
    .byte %00011110, %00110011, %00001101
    .byte %00000011, %00100110, %00000110
    .byte %00000001, %10001100, %00000000
    .byte %00000000, %10011000, %00000000
    .byte %00000000, %10110000, %00000000
    .byte %00000000, %11000000, %00000000
    .byte 0

    .byte %00000000, %11111111, %11111110
    .byte %00000001, %11111111, %11111111
    .byte %00000001, %11111111, %11111111
    .byte %00000000, %11111111, %11111111
    .byte %00000000, %01111111, %11111111
    .byte %00000000, %00111111, %11111111
    .byte %00000000, %00011111, %11111111
    .byte %00000000, %00111111, %11111111
    .byte %00000000, %01111111, %11111111
    .byte %00000000, %11111111, %11111111
    .byte %00000001, %11111111, %11111111
    .byte %00000011, %11111111, %11111111
    .byte %00000111, %11111111, %11111111
    .byte %00001111, %11111111, %11111111
    .byte %00011111, %11111111, %10011111
    .byte %00011111, %11111111, %00001111
    .byte %00000011, %11111110, %00000110
    .byte %00000001, %11111100, %00000000
    .byte %00000000, %11111000, %00000000
    .byte %00000000, %11110000, %00000000
    .byte %00000000, %11000000, %00000000
    .byte 0


    .byte %00000000, %11000000, %00000000
    .byte %00000000, %10110000, %00000000
    .byte %00000000, %10011000, %00000000
    .byte %00000001, %10001100, %00000000
    .byte %00000011, %00100110, %00000110
    .byte %00011110, %00110011, %00001101
    .byte %00010000, %00110001, %10011001
    .byte %00001101, %11110000, %11010001
    .byte %00000110, %11110010, %01100001
    .byte %00000011, %00000011, %00001001
    .byte %00000001, %10000011, %00011001
    .byte %00000000, %11011111, %00111001
    .byte %00000000, %01101111, %00111001
    .byte %00000000, %00100000, %00111001
    .byte %00000000, %00010000, %00111001
    .byte %00000000, %00110011, %11111001
    .byte %00000000, %01100111, %11111001
    .byte %00000000, %11001111, %11111001
    .byte %00000001, %10000000, %00000001
    .byte %00000001, %00000000, %00000001
    .byte %00000000, %11111111, %11111110
    .byte 0

    .byte %00000000, %11000000, %00000000
    .byte %00000000, %11110000, %00000000
    .byte %00000000, %11111000, %00000000
    .byte %00000001, %11111100, %00000000
    .byte %00000011, %11111110, %00000110
    .byte %00011111, %11111111, %00001111
    .byte %00011111, %11111111, %10011111
    .byte %00001111, %11111111, %11011111
    .byte %00000111, %11111111, %11111111
    .byte %00000011, %11111111, %11111111
    .byte %00000001, %11111111, %11111111
    .byte %00000000, %11111111, %11111111
    .byte %00000000, %01111111, %11111111
    .byte %00000000, %00111111, %11111111
    .byte %00000000, %00011111, %11111111
    .byte %00000000, %00111111, %11111111
    .byte %00000000, %01111111, %11111111
    .byte %00000000, %11111111, %11111111
    .byte %00000001, %11111111, %11111111
    .byte %00000001, %11111111, %11111111
    .byte %00000000, %11111111, %11111110
    .byte 0

    .byte %00000011, %11111110, %00000000
    .byte %00001100, %00000001, %10000000
    .byte %00011011, %11111110, %11000000
    .byte %00110000, %00000000, %01100000
    .byte %01100110, %01010011, %00110000
    .byte %01001110, %11011011, %10010000
    .byte %10010000, %00000000, %01001000
    .byte %10000111, %00000111, %00001000
    .byte %10001111, %10001111, %10001000
    .byte %10001111, %10001111, %10001000
    .byte %10001111, %00000111, %10001000
    .byte %10001100, %00000001, %10001000
    .byte %10001110, %00000011, %10001000
    .byte %10001111, %00000111, %10001000
    .byte %10001111, %10001111, %10001000
    .byte %01000111, %10001111, %00010000
    .byte %01100011, %00000110, %00110000
    .byte %00110000, %00000000, %01100000
    .byte %00011011, %11111110, %11000000
    .byte %00001100, %00000001, %10000000
    .byte %00000011, %11111110, %00000000
    .byte 0

    .byte %00000011, %11111110, %00000000
    .byte %00001111, %11111111, %10000000
    .byte %00011111, %11111111, %11000000
    .byte %00111111, %11111111, %11100000
    .byte %01111111, %11111111, %11110000
    .byte %01111111, %11111111, %11110000
    .byte %11111111, %11111111, %11111000
    .byte %11111111, %11111111, %11111000
    .byte %11111111, %11111111, %11111000
    .byte %11111111, %11111111, %11111000
    .byte %11111111, %11111111, %11111000
    .byte %11111111, %11111111, %11111000
    .byte %11111111, %11111111, %11111000
    .byte %11111111, %11111111, %11111000
    .byte %11111111, %11111111, %11111000
    .byte %01111111, %11111111, %11110000
    .byte %01111111, %11111111, %11110000
    .byte %00111111, %11111111, %11100000
    .byte %00011111, %11111111, %11000000
    .byte %00001111, %11111111, %10000000
    .byte %00000011, %11111110, %00000000
    .byte 0

    .res 64*2, 0


; bit_rev_tbl:
; .byte $00, $80, $40, $c0, $20, $a0, $60, $e0
; .byte $10, $90, $50, $d0, $30, $b0, $70, $f0
; .byte $08, $88, $48, $c8, $28, $a8, $68, $e8
; .byte $18, $98, $58, $d8, $38, $b8, $78, $f8
; .byte $04, $84, $44, $c4, $24, $a4, $64, $e4
; .byte $14, $94, $54, $d4, $34, $b4, $74, $f4
; .byte $0c, $8c, $4c, $cc, $2c, $ac, $6c, $ec
; .byte $1c, $9c, $5c, $dc, $3c, $bc, $7c, $fc
; .byte $02, $82, $42, $c2, $22, $a2, $62, $e2
; .byte $12, $92, $52, $d2, $32, $b2, $72, $f2
; .byte $0a, $8a, $4a, $ca, $2a, $aa, $6a, $ea
; .byte $1a, $9a, $5a, $da, $3a, $ba, $7a, $fa
; .byte $06, $86, $46, $c6, $26, $a6, $66, $e6
; .byte $16, $96, $56, $d6, $36, $b6, $76, $f6
; .byte $0e, $8e, $4e, $ce, $2e, $ae, $6e, $ee
; .byte $1e, $9e, $5e, $de, $3e, $be, $7e, $fe
; .byte $01, $81, $41, $c1, $21, $a1, $61, $e1
; .byte $11, $91, $51, $d1, $31, $b1, $71, $f1
; .byte $09, $89, $49, $c9, $29, $a9, $69, $e9
; .byte $19, $99, $59, $d9, $39, $b9, $79, $f9
; .byte $05, $85, $45, $c5, $25, $a5, $65, $e5
; .byte $15, $95, $55, $d5, $35, $b5, $75, $f5
; .byte $0d, $8d, $4d, $cd, $2d, $ad, $6d, $ed
; .byte $1d, $9d, $5d, $dd, $3d, $bd, $7d, $fd
; .byte $03, $83, $43, $c3, $23, $a3, $63, $e3
; .byte $13, $93, $53, $d3, $33, $b3, $73, $f3
; .byte $0b, $8b, $4b, $cb, $2b, $ab, $6b, $eb
; .byte $1b, $9b, $5b, $db, $3b, $bb, $7b, $fb
; .byte $07, $87, $47, $c7, $27, $a7, $67, $e7
; .byte $17, $97, $57, $d7, $37, $b7, $77, $f7
; .byte $0f, $8f, $4f, $cf, $2f, $af, $6f, $ef
; .byte $1f, $9f, $5f, $df, $3f, $bf, $7f, $ff




; flip_copy:
;     ldy #0
; sprite_copy_loop:
;     lda arrow_bin+64*0,y
;     sta sprite_data+64*0,y
;     tax
;     lda bit_rev_tbl,x
;     sta sprite_data+64*2+2,y
;     lda arrow_bin+64*1,y
;     sta sprite_data+64*1,y
;     tax
;     lda bit_rev_tbl,x
;     sta sprite_data+64*3+2,y

;     iny

;     lda arrow_bin+64*0,y
;     sta sprite_data+64*0,y
;     tax
;     lda bit_rev_tbl,x
;     sta sprite_data+64*2+0,y
;     lda arrow_bin+64*1,y
;     sta sprite_data+64*1,y
;     tax
;     lda bit_rev_tbl,x
;     sta sprite_data+64*3+0,y

;     iny

;     lda arrow_bin+64*0,y
;     sta sprite_data+64*0,y
;     tax
;     lda bit_rev_tbl,x
;     sta sprite_data+64*2-2,y
;     lda arrow_bin+64*1,y
;     sta sprite_data+64*1,y
;     tax
;     lda bit_rev_tbl,x
;     sta sprite_data+64*3-2,y

;     iny

;     tya
;     cmp #63
;     bne sprite_copy_loop



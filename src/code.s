color_black = $0
color_white = $1

screen_ram := $0400
reg_sid_base := $d400
reg_bg_color := $d021
reg_bd_color := $d020

; Fill screen with spaces and set fg to Y
.export _clear_scr
_clear_scr:
    tay
    ldx #color_black
    stx reg_bg_color
    stx reg_bd_color
clear_loop:
    lda #$20            ; screen code for SPACE
    sta $0400,x         ; fill four areas with 256 spacebar characters
    sta $0500,x 
    sta $0600,x 
    sta $06e8,x 
    ; set foreground color
    tya
    sta $d800,x  
    sta $d900,x
    sta $da00,x
    sta $dae8,x
    inx                 ; increment X
    bne clear_loop      ; loop until X is zero (ie 256)
    rts                 ; return from this subroutine


.export _set_screen_idx
_set_screen_idx:
    clc
    sta ld1+2
    sta ld2+2
    adc #1
    sta ld3+2
    adc #1
    sta ld4+2
    ldx #250
screen_loop:
ld1:
    lda $FF00,x
    sta $0400,x
ld2:
    lda $FFfa,x
    sta $04fa,x
ld3:
    lda $FFf4,x
    sta $05f4,x
ld4:
    lda $FFee,x
    sta $06ee,x

    dex
    bne screen_loop
    rts
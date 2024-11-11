color_black = $0
color_white = $1

screen_ram := $0400
reg_sid_base := $d400
reg_bg_color := $d021
reg_bd_color := $d020

; Fill screen with black
; Clobbers: A, X
.export _clear_scr
_clear_scr:
    ldx #color_black
    stx reg_bg_color
    stx reg_bd_color
clear_loop:
    lda #$20            ; screen code for SPACE
    sta $0400,x         ; fill four areas with 256 spacebar characters
    sta $0500,x 
    sta $0600,x 
    sta $06e8,x 
    lda #color_white    ; set foreground to black in Color Ram 
    sta $d800,x  
    sta $d900,x
    sta $da00,x
    sta $dae8,x
    inx                 ; increment X
    bne clear_loop      ; loop until X is zero (ie 256)
    rts                 ; return from this subroutine

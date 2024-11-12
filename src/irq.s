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
reg_bd_color := $d020


.export _init_irq
_init_irq:
    
    sei         ; set interrupt disable flag

    ldy #%01111111
    sty $dc0d   ; Turn off CIAs Timer interrupts
    sty $dd0d   ; Turn off CIAs Timer interrupts
    lda $dc0d   ; cancel all CIA-IRQs in queue/unprocessed
    lda $dd0d   ; cancel all CIA-IRQs in queue/unprocessed
    
    lda #$01    ; Set Interrupt Request Mask...
    sta $d01a   ; ...we want IRQ by Rasterbeam

    lda #<irq   ; point IRQ Vector to our custom irq routine
    ldx #>irq 
    sta $314    ; store in $314/$315
    stx $315   

    lda #192    ; trigger first interrupt at end of frame
    sta $d012

    lda $d011   ; Bit#0 of $d011 is basically...
    and #$7f    ; ...the 9th Bit for $d012
    sta $d011   ; we need to make sure it is set to zero 

    cli         ; clear interrupt disable flag

    rts

first_irq:
    lda #32
    sta $d012

    dec $d019       ; acknowledge IRQ

    ; lda #color_red
    ; sta reg_bd_color

    lda #<second_irq
    ldx #>second_irq
    sta $314
    stx $315

    jmp $ea81

second_irq:
    lda #78
    clc
    adc _chart_shift
    sta $d012

    lda _chart_shift
    cmp #12
    bcc first_step_vanish
    cmp #18
    bcs first_step_slide
    lda #color_white
    sta $d027
    sta $d02b
    sta $d028
    sta $d02a
    sta $d029
    lda #16
first_step_slide:
    adc #34
    sta $d009
    sta $d007
    sta $d005
    sta $d003
    sta $d001

    lda $d015
    and #%11100000
    ora _chart_line
    sta $d015


first_step_vanish:
    dec $d019       ; acknowledge IRQ

    ; lda #color_blue
    ; sta reg_bd_color

    lda #<third_irq
    ldx #>third_irq
    sta $314
    stx $315

    jmp $ea81


third_irq:
    lda #<irq
    ldx #>irq
    sta $314
    stx $315

    ; lda #color_purple
    ; sta reg_bd_color

    clc
    lda #82
    adc _chart_shift

    sta $d012
    sta $d009
    sta $d007
    sta $d005
    sta $d003
    sta $d001

    lda $d015
    and #%11100000
    ora _chart_line+1
    sta $d015

    clc
    lda $d012
    adc #46        ; trigger next interrupt
    sta $d012

    lda #color_blue
    sta $d027
    sta $d02b

    lda #color_red
    sta $d028
    sta $d02a

    lda #color_yellow
    sta $d029

    dec $d019       ; acknowledge IRQ
    jmp $ea81

last_irq:
    lda #<first_irq
    ldx #>first_irq
    sta $314
    stx $315

    ; lda #color_green
    ; sta reg_bd_color

    lda #0
    sta $d012
    dec $d019       ; acknowledge IRQ
    jmp irq_stablizer_loop

irq:    
    ; lda #color_black
    ; sta reg_bd_color

    lda $d012
    cmp #204
    bcs frame_irq 
    ; carry is clear
    adc #48        ; trigger next interrupt in 48 rows
    sta $d012

    dec $d019       ; acknowledge IRQ

    lda $d012
irq_stablizer_loop:
    cmp $d012
    beq irq_stablizer_loop
    
    lda $d015
    and #%11100000
line_read:
    ora _chart_line+1
    sta $d015

    lda $d009       ; Sprite 4 Y
    adc #$30        ; Shift down 48
    sta $d009

    lda $d007       ; Sprite 3 Y
    adc #$30        ; Shift down 48
    sta $d007

    lda $d005       ; Sprite 2 Y
    adc #$30        ; Shift down 48
    sta $d005

    lda $d003       ; Sprite 1 Y
    adc #$30        ; Shift down 48
    sta $d003

    lda $d001       ; Sprite 0 Y
    adc #$30        ; Shift down 48
    sta $d001

    inc line_read+1

    jmp $ea81


.import _irq_handler
frame_irq:
    ; reset self modifying chart line read
    lda #<_chart_line+1
    sta line_read+1

    jsr _irq_handler ; call our custom irq handler

    ; burn cycles to avoid stutter
    ldx #48
    dex
    bne *-1
    stx $d012

    lda #<last_irq
    ldx #>last_irq
    sta $314
    stx $315

    jmp $ea81        ; return to kernel interrupt routine

.segment "DATA"
.align 8
.export _chart_line
_chart_line:
    .byte %00000
    .byte %00000
    .byte %00000
    .byte %00000
    .byte %00000
    .byte %11111
.export _chart_shift
_chart_shift:
    .byte 44


;     ; A Raster Compare IRQ is triggered on cycle 0 on the current $d012 line
;     ; The MPU needs to finish it's current OP code before starting the Interrupt Handler,
;     ; meaning a 0 -> 7 cycles delay depending on OP code.
;     ; Then a 7 cycle delay is spendt invoking the Interrupt Handler (Push SR/PC to stack++)
;     ; Then 13 cycles for storing registers (pha, txa, pha, tya, pha)

;     ; CYCLECOUNT: [20 -> 27] cycles after Raster IRQ occurred.

;     ; Set up Wedge IRQ vector
;     lda #<WedgeIRQ
;     sta $fffe
;     lda #>WedgeIRQ
;     sta $ffff

;     ; Set the Raster IRQ to trigger on the next Raster line
;     inc $d012

;     ; Acknowlege current Raster IRQ
;     ; lda #$01
;     ; sta $d019
;     dec $d019       ; acknowledge IRQ


;     ; Store current Stack Pointer (will be messed up when the next IRQ occurs)
;     tsx

;     ; Allow IRQ to happen (Remeber the Interupt flag is set by the Interrupt Handler).
;     cli

;     ; Execute NOPs untill the raster line changes and the Raster IRQ triggers
;     nop
;     nop
;     nop
;     nop
;     nop
;     nop
;     nop
;     nop
;     nop
;     nop
;     nop
;     nop

;     ; CYCLECOUNT: [64 -> 71]

; WedgeIRQ:
;     ; At this point the next Raster Compare IRQ has triggered and the jitter is max 1 cycle.
;     ; CYCLECOUNT: [7 -> 8] (7 cycles for the interrupt handler + [0 -> 1] cycle Jitter for the NOP)

;     ; Restore previous Stack Pointer (ignore the last Stack Manipulation by the IRQ)
;     txs

;     ; NTSC-64    
;     ;---------
;     ldx #$08 
; stablizer_loop:
;     dex
;     bne stablizer_loop
;     nop
;     nop

;     ; Check if $d012 is incremented and rectify with an aditional cycle if neccessary
;     lda $d012
;     cmp $d012  ; <- critical instruction (ZERO-Flag will indicate if Jitter = 0 or 1)

;     ; CYCLECOUNT: [61 -> 62] <- Will not work if this timing is wrong

;     ; cmp $d012 is originally a 5 cycle instruction but due to piplining tech. the
;     ; 5th cycle responsible for calculating the result is executed simultaniously
;     ; with the next OP fetch cycle (first cycle of beq *+2).

;     ; Add one cycle if $d012 wasn't incremented (Jitter / ZERO-Flag = 0)
;     beq *+2
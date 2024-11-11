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

    lda #$00    ; trigger first interrupt at row zero
    sta $d012

    lda $d011   ; Bit#0 of $d011 is basically...
    and #$7f    ; ...the 9th Bit for $d012
    sta $d011   ; we need to make sure it is set to zero 

    cli         ; clear interrupt disable flag

    rts

.import _irq_handler
irq:
    dec $d019        ; acknowledge IRQ
    jsr _irq_handler ; call our custom irq handler
    jmp $ea81        ; return to kernel interrupt routine
.thumb

.align

.macro blh to, reg
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

.equ GetItemHit, 0x80175F5
.equ GetItemCrit, 0x8017625

.global CalcHit
.type CalcHit, %function

CalcHit:
    push {r4, lr}
    mov  r4, r0
    add  r0, #0x4A
    ldrh r0, [r0]
    blh  GetItemHit, r3

    @okay, get dex, double it, and add it to weapon hit
    mov  r1, #0x15
    ldsb r1, [r4, r1]
    lsl  r1, #0x1
    add  r0, r1

    @store that value!
    mov  r1, #0x60
    add  r1, r4
    strh r0, [r1]

    pop  {r4}
    pop  {r0}
    bx   r0

.align
.ltorg

.global CalcAvoid
.type CalcAvoid, %function

CalcAvoid:
    push {r4, lr}
    mov  r4, r0

    @get unit luck, then double it
    add  r0, #0x19
    mov  r1, #0x0
    ldsb r0, [r0, r1]
    lsl  r0, #0x1

    mov  r1, #0x57
    add  r1, r4
    ldrb r1, [r1]
    add  r0, r1
    cmp  r0, #0x0
    bgt  StoreAvoid
        mov  r0, #0x0

    @store the value
    StoreAvoid:
    mov  r1, r4
    add  r1, #0x62
    strh r0, [r1]

    pop  {r4}
    pop  {r0}
    bx   r0

.align
.ltorg

.global CalcCrit
.type CalcCrit, %function

CalcCrit:
    push {r4, lr}
    mov  r4, r0
    add  r0, #0x4A
    ldrh r0, [r0]
    blh  GetItemCrit, r3

    mov  r1, r4
    add  r1, #0x66
    strh r0, [r1]

    pop  {r4}
    pop  {r0}
    bx   r0

.align
.ltorg

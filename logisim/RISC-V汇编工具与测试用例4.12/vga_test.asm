	.file	"vga_test.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	set_pixel
	.type	set_pixel, @function
set_pixel:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	lw	a5,-36(s0)
	blt	a5,zero,.L5
	lw	a4,-36(s0)
	li	a5,127
	bgt	a4,a5,.L5
	lw	a5,-40(s0)
	blt	a5,zero,.L5
	lw	a4,-40(s0)
	li	a5,95
	bgt	a4,a5,.L5
	li	a5,1048576
	sw	a5,-20(s0)
	lw	a5,-36(s0)
	slli	a4,a5,7
	lw	a5,-40(s0)
	add	a5,a4,a5
	slli	a5,a5,2
	lw	a4,-20(s0)
	add	a5,a4,a5
	lw	a4,-44(s0)
	sw	a4,0(a5)
	j	.L1
.L5:
	nop
.L1:
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	set_pixel, .-set_pixel
	.align	2
	.globl	clear_screen
	.type	clear_screen, @function
clear_screen:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	li	a5,1048576
	sw	a5,-24(s0)
	sw	zero,-20(s0)
	j	.L7
.L8:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-24(s0)
	add	a5,a4,a5
	sw	zero,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L7:
	lw	a4,-20(s0)
	li	a5,12288
	blt	a4,a5,.L8
	nop
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	clear_screen, .-clear_screen
	.align	2
	.globl	render_screen
	.type	render_screen, @function
render_screen:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	li	a5,1048576
	sw	a5,-24(s0)
	sw	zero,-20(s0)
	j	.L10
.L11:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a3,-24(s0)
	add	a5,a3,a5
	lw	a4,0(a4)
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L10:
	lw	a4,-20(s0)
	li	a5,12288
	blt	a4,a5,.L11
	nop
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	render_screen, .-render_screen
	.globl	__mulsi3
	.align	2
	.globl	render_image
	.type	render_image, @function
render_image:
	addi	sp,sp,-64
	sw	ra,60(sp)
	sw	s0,56(sp)
	sw	s1,52(sp)
	sw	s2,48(sp)
	addi	s0,sp,64
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	sw	a4,-52(s0)
	sw	zero,-20(s0)
	j	.L13
.L16:
	sw	zero,-24(s0)
	j	.L14
.L15:
	lw	a4,-36(s0)
	lw	a5,-20(s0)
	add	s1,a4,a5
	lw	a4,-40(s0)
	lw	a5,-24(s0)
	add	s2,a4,a5
	lw	a1,-44(s0)
	lw	a0,-20(s0)
	call	__mulsi3
	mv	a5,a0
	mv	a4,a5
	lw	a5,-24(s0)
	add	a5,a4,a5
	slli	a5,a5,2
	lw	a4,-52(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	mv	a2,a5
	mv	a1,s2
	mv	a0,s1
	call	set_pixel
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L14:
	lw	a4,-24(s0)
	lw	a5,-44(s0)
	blt	a4,a5,.L15
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L13:
	lw	a4,-20(s0)
	lw	a5,-48(s0)
	blt	a4,a5,.L16
	nop
	nop
	lw	ra,60(sp)
	lw	s0,56(sp)
	lw	s1,52(sp)
	lw	s2,48(sp)
	addi	sp,sp,64
	jr	ra
	.size	render_image, .-render_image
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	t1,-49152
	add	sp,sp,t1
	call	clear_screen
	sw	zero,-20(s0)
	j	.L18
.L24:
	sw	zero,-24(s0)
	j	.L19
.L23:
	lw	a5,-20(s0)
	beq	a5,zero,.L20
	lw	a4,-20(s0)
	li	a5,95
	beq	a4,a5,.L20
	lw	a5,-24(s0)
	beq	a5,zero,.L20
	lw	a4,-24(s0)
	li	a5,127
	bne	a4,a5,.L21
.L20:
	lw	a5,-20(s0)
	slli	a4,a5,7
	lw	a5,-24(s0)
	add	a5,a4,a5
	li	a4,-49152
	addi	a3,s0,-16
	add	a4,a3,a4
	slli	a5,a5,2
	add	a5,a4,a5
	li	a4,4096
	addi	a4,a4,-256
	sw	a4,-8(a5)
	j	.L22
.L21:
	lw	a5,-20(s0)
	slli	a4,a5,7
	lw	a5,-24(s0)
	add	a5,a4,a5
	li	a4,-49152
	addi	a3,s0,-16
	add	a4,a3,a4
	slli	a5,a5,2
	add	a5,a4,a5
	li	a4,15
	sw	a4,-8(a5)
.L22:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L19:
	lw	a4,-24(s0)
	li	a5,127
	ble	a4,a5,.L23
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L18:
	lw	a4,-20(s0)
	li	a5,95
	ble	a4,a5,.L24
	li	a5,-49152
	addi	a5,a5,-8
	addi	a4,s0,-16
	add	a5,a4,a5
	mv	a0,a5
	call	render_screen
.L25:
	j	.L25
	.size	main, .-main
	.ident	"GCC: () 10.2.0"

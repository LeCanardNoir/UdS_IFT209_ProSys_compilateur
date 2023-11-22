.include "/root/SOURCES/ift209/tools/ift209.as"

.global Compile


.section ".text"

/********************************************************************************
*																				*
*	Sous-programme qui compile un arbre syntaxique et produit le code binaire  	*
*	des instructions.															*
*																				*
*	Paramètres:																	*
*		x0: adresse du noeud racine												*
*		x1: adresse du tableau d'octets pour écrire le code compilé				*
*															                    *
*	Auteurs: 																	*
*																				*
********************************************************************************/

Compile:
	SAVE
	mov		x19, x0					// load root address
	mov		x9, x1					// load array address
	mov		x10, #0					// size counter
	bl		Compile_REC


	mov		x11, 0x21
	str		x11, [x9], #1
	mov		x11, #0
	str		x11, [x9], #1
	mov		x11, #0
	str		x11, [x9]

	add		x10, x10, #2
	mov		x0, x10
	mov		x1, x9
	

	RESTORE
	ret


Compile_REC:
	SAVE
	ldrb	w20, [x19]				// load current type
	ldrb	w21, [x19, #4]			// load current value
	ldr		x22, [x19, #8]			// load left child node address
	ldr		x23, [x19, #16]			// load right child node address

	// PUSH
	cmp		x20, #0
	b.ne	Compile_LEFT			// if type != 0
	mov		x24, 0x40
	str		x24, [x9], #1
	
	mov		w15, w21
	lsl		w15, w15, #16
	lsr		w15, w15, #24
	strb	w15, [x9], #1			// save value in array
	
	lsl		w21, w21, #24
	lsr		w21, w21, #24
	strb	w21, [x9], #1
	
	add		x10, x10, #3			// add size
	b.al	Compile_REC_END

Compile_LEFT:
	cmp		x22, #0
	b.eq	Compile_RIGHT			// if left addr != 0
	mov		x19, x22
	bl		Compile_REC

Compile_RIGHT:
	cmp		x23, #0
	b.eq	Compile_REC_END				// if right addr != 0
	mov		x19, x23
	bl		Compile_REC
	
	cmp		x21, #0	
	b.eq	Compile_ADD
	cmp		x21, #1	
	b.eq	Compile_SUB
	cmp		x21, #2
	b.eq	Compile_MUL
	cmp		x21, #3
	b.eq	Compile_DIV

Compile_ADD: // 0x48
	mov		x21, 0x48
	b.al	Compile_OP

Compile_SUB:// 0x4c
	mov		x21, 0x4c
	b.al	Compile_OP
	
Compile_MUL:// 0x50
	mov		x21, 0x50
	b.al	Compile_OP
	
Compile_DIV:// 0x54
	mov		x21, 0x54

Compile_OP:
	strb	w21, [x9], #1			// save op value in array
	add		x10, x10, #1			// add size

Compile_REC_END:
	RESTORE
	ret

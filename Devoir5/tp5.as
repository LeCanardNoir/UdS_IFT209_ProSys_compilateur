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
	mov		x2, #0					// array index
	bl		Compile_REC				// Start record loop


	mov		x11, 0x21				// WRITE code
	str		x11, [x9, x2]			// Put WRITE code in array
	add		x2, x2, #1				// array ++
	mov		x11, 0x00				// HALT code
	str		x11, [x9, x2]			// Put HALT code in array

	add		x10, x10, #2			// size ++
	mov		x0, x10					// param size 
	mov		x1, x9					// param array address
	

	RESTORE
	ret								// EXIT


Compile_REC:
	SAVE
	ldrb	w20, [x19]				// load current type
	ldr		x21, [x19, #4]			// load current value
	ldr		x22, [x19, #8]			// load left child node address
	ldr		x23, [x19, #16]			// load right child node address
	ldrb	w25, [x19, #4]			// backup current node type address

	// PUSH
	cmp		x20, #0
	b.ne	Compile_LEFT			// if type != 0 go LEFT
	mov		x24, 0x40				// digit code
	str		x24, [x9, x2]			// save digit code in array
	add		x2, x2, #1				// array index ++
	
	mov		x15, x21
	lsl		x15, x15, #48
	lsr		x15, x15, #56
	str		x15, [x9, x2]//, #1			// save value in array
	add		x2, x2, #1
	
	//lsl		x21, x21, #56
	//lsr		x21, x21, #56
	str		x21, [x9, x2]//, #1
	add		x2, x2, #1
	
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
	
	mov		w21, w25
	cmp		w21, #0	
	b.eq	Compile_ADD
	cmp		w21, #1	
	b.eq	Compile_SUB
	cmp		w21, #2
	b.eq	Compile_MUL
	cmp		w21, #3
	b.eq	Compile_DIV

Compile_ADD: // 0x48
	mov		w21, 0x48
	b.al	Compile_OP

Compile_SUB:// 0x4c
	mov		w21, 0x4c
	b.al	Compile_OP
	
Compile_MUL:// 0x50
	mov		w21, 0x50
	b.al	Compile_OP
	
Compile_DIV:// 0x54
	mov		w21, 0x54

Compile_OP:
	strb	w21, [x9, x2]//, #1			// save op value in array
	add		x2, x2, #1
	add		x10, x10, #1			// add size

Compile_REC_END:
	RESTORE
	ret

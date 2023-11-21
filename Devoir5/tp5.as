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
	mov		x25, x19

	// PUSH
	cmp		x20, #0
	b.ne	Compile_LEFT			// if type != 0
	mov		x24, 0x40
	str		x24, [x9], #1
	str		xzr, [x9], #1
	str		x21, [x9], #1			// save value in array
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

	ldr		x21, [x25, #4]
	add		x21, x21, 0x30
	str		x21, [x9], #1			// save op value in array
	add		x10, x10, #1			// add size

Compile_REC_END:
	RESTORE
	ret
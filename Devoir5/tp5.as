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
	mov		x19, x0					// load root address
	mov		x10, x1					// load array address
	mov		x11, #0					// size counter
	mov		x12, x1					// Backup root array address

Compile_REC:
	SAVE
	ldrb	w20, [x19]				// load current type
	ldrb	w21, [x19, #4]			// load current value
	cmp		x20, #0
	bl		Compile_REC_PUSH	// if type == 0

	ldr		x22, [x19, #8]			// load left child node address
	cmp		x22, #0
	bl		Compile_REC_LEFT	// if left addr != 0

	ldr		x23, [x19, #16]				// load right child node address
	cmp		x23, #0
	bl		Compile_REC_RIGHT	// if right addr != 0
	
	str		x21, [x10], #1			// save op value in array
	add		x11, x11, #1			// add size

	RESTORE
	ret

	b.al	Compile_END

Compile_REC_PUSH:
	str		x21, [x10], #3			// save value in array
	add		x11, x11, #3			// add size
	ret

Compile_REC_LEFT:
	mov		x19, x22
	b.al	Compile_REC

Compile_REC_RIGHT:
	mov		x19, x23
	b.al	Compile_REC

Compile_END:
	mov		x9, #100
	str		x9, [x10], #1
	mov		x9, #1
	str		x9, [x10], #1
	mov		x9, #0
	str		x9, [x10]

	mov		x0, x11
	mov		x1, x12
	


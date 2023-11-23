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

	add		x10, x10, #2			// add size +2
	mov		x0, x10					// param size 
	mov		x1, x9					// param array address
	

	RESTORE
	ret								// EXIT sub-program


Compile_REC:
	SAVE
	ldrb	w20, [x19]				// load current type
	ldr		x21, [x19, #4]			// load current value
	ldr		x22, [x19, #8]			// load left child node address
	ldr		x23, [x19, #16]			// load right child node address
	ldrb	w25, [x19, #4]			// backup current node value

	// PUSH
	cmp		x20, #0
	b.ne	Compile_LEFT			// if type != 0 -> go LEFT
	mov		x24, 0x40				// digit code
	str		x24, [x9, x2]			// save digit code in array
	add		x2, x2, #1				// array index ++
	
	lsr		x15, x21, #8			// keep last byte
	str		x15, [x9, x2]			// save last byte value in array
	add		x2, x2, #1				// array index ++

	bic		x21, x21, 0xFFFFFF00	// keep first byte
	str		x21, [x9, x2]			// save first byte value in array
	add		x2, x2, #1				// array index ++
	
	add		x10, x10, #3			// add size +3
	b.al	Compile_REC_END			// no child get parent

Compile_LEFT:
	cmp		x22, #0
	b.eq	Compile_RIGHT			// if left address == 0 -> Goto right
	mov		x19, x22				// else param left node address
	bl		Compile_REC				// get left record

Compile_RIGHT:
	cmp		x23, #0					// 
	b.eq	Compile_REC_END			// if right address == 0 -> no child get parent
	mov		x19, x23				// else param right node address
	bl		Compile_REC				// get right record
	
	mov		w21, w25				// get current node value
	mov		x25, #4					// operator num factor
	mul		x21, x21, x25			// multiply operator num by factor
	add		x21, x21, 0x48			// Add 0x48 to operator

Compile_OP:
	strb	w21, [x9, x2]			// save op value in array
	add		x2, x2, #1				// array index ++
	add		x10, x10, #1			// add size +1

Compile_REC_END:
	RESTORE
	ret								// end record

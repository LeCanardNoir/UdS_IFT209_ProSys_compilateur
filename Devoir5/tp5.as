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
	mov		x19, x0				// Get root node address
	mov		x20, x1				// Get return array address
	mov		x21, #0				// instruction size
	mov		x22, x19			// current node address
	mov		x23, #8				// stack jump
	mov		x24, #0				// stack steps

CompileRec:

	ldrh	w9, [x22]			// load node type
	cmp		x9, #0
	b.eq	CompileRec_PUSH		// if type == 0 PUSH
	cmp		x9, #1
	b.eq	CompileRec_StackOps

	mov		x12, x22			// get current node address
	ldrh	w10, [x12, #4]	 	// load node value
	add		x11, x10, #48		// get op node value

CompileRec_left:
	ldr		x22, [x12, #8]		// load left node address
	bl		CompileRec

CompileRec_right:
	ldr		x22, [x12, #16]		// load right node address
	bl		CompileRec

CompileRec_opEnd:
	add		x21, x21, #1		// add 1 bytes to instruction size
	str		x11, [x20], #1		// save op type value (add=0, ...)

	b.al	CompileEnd

CompileRec_PUSH:

	ldr		x13, [x22, #4]	 	// load node value
	str		x13, [x20], #3		// save value in return array, address + 3 bytes
	add		x21, x21, #3		// Add 
	ret

CompileRec_StackOps:
	mul		x9, x23, x24
	str		x12, [sp, x9]
	ret

CompileEnd:
	mov		x9, #100			
	str		x9, [x20], #1		// save WRITE instruction
	mov		x9, #1
	str		x9, [x20], #1		// save %d instruction
	mov		x9, #0
	str		x9, [x20], #1		// save HALT instruction

	mov		x0, x21				// param instruction size
	mov		x1, x20				// param code array

	RESTORE
	ret


.section 		".rodata"
pfnode:			.asciz "\nCurrent Addr: %x\nType: %x, Value: %x, Left addr: %x, Right addr: %x\n\n"
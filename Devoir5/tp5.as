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
	mov		x21, #0				// instruction size amount
	mov		x22, x19			// current node address

CompileRec:
	ldr		x9, [x22]			// load node type
	cmp		x9, #0
	b.eq	CompileRec_PUSH		// if type == 0 PUSH

CompileRec_PUSH:
	ldr		x10, [x22, #4]	 	// load node value
	str		x10, [x20], #3		// save value in return array, address + 3 bytes
	add		x21, x21, #3		// Add 

	adr		x0, pfnode			// test print result
	mov		x1, x22
	mov		x2, x9
	mov		x3, x10
	ldr		x4,	[x22, #8]
	ldr		x5, [x22, #16]
	bl		printf

CompileRec_OP:
	ldr		x22, [x22, #8]
	bl		CompileRec

	ldr		x22, [x22, #16]
	bl		CompileRec

	add		x21, x21, #1





CompileEnd:
	mov		x0, x21
	mov		x1, x20

	RESTORE
	ret


.section 		".rodata"
pfnode:			.asciz "\nCurrent Addr: %x\nType: %x, Value: %x, Left addr: %x, Right addr: %x\n\n"
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
	mov			x19, x0			// get current node address
	mov			x20, x1			// get array address for code
	ldr			x21, [x19, #0]	// current operation

CompileRec:
	

CompileRec_left:

	adr			x0, pfnode
	mov			x1, x19			// Current address
	ldr			x2,[x19],#4		// load type
	ldr			x3,[x19],#4		// load value

	cbnz		x2, CompileRec_stack	

	ldr			x4,[x19],#8		// load left node
	mov			x5,[x19]		// load right node

	cmp			x4, #0
	csel		x19, x4, x5, ne	// next node address
	mov			x19, x6			// set next address
	bl			printf	

	cbnz		x19, CompileRec_left

CompileRec_right:

	mov			x0, #0
	str			x0, [x20]
	mov			x1, x20
	b.al		Compile_end

CompileRec_stack:	
	str			x3, [sp]		
	ret		

Compile_end:
	RESTORE
	ret

.section 		".rodata"
pfnode:			.asciz "\nCurrent Addr: %x\nType: %x, Value: %x, Left addr: %x, Right addr: %x, Next Addr: %x\n\n"
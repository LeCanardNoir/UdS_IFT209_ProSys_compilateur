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
	mov			x21, x19		// fist op address
	mov			x22, x21		// last op address
	mov			x9, #0			// op type 0
	mov			x10, #1			// op type 1

CompileRec:
	

CompileRec_left:

	adr			x0, pfnode
	mov			x1, x19			// Current address
	ldr			x2,[x19],#4		// load type
	mov			x3, x19

	cmp			x2, #0
	csel		x22, x3, x22, eq

	ldr			x3,[x19],#4		// load value
	ldr			x4,[x19],#8		// load left node address
	ldr			x5,[x19]		// load right node address

	mov			x19, x4			// next node address
	bl			printf	

	cbnz		x19, CompileRec_left


CompileRec_right:
	b.al		Compile_end	

Compile_end:
	mov			x1, x20
	mov			x0, #0
	mov			x9, #0
	str			x9, [x1]
	RESTORE
	ret


.section 		".rodata"
pfnode:			.asciz "\nCurrent Addr: %x\nType: %x, Value: %x, Left addr: %x, Right addr: %x\n\n"

.include "/root/SOURCES/ift209/tools/ift209.as"

.global Compile

.section 		".rodata"
pfnode:			.asciz "\nCurrent Addr: %x\nType: %x, Value: %x, Left addr: %x, Right addr: %x\n\n"

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
	mov		x23, #0
	mov		x19, x0

Compile_loop:
	mov		x20, x1

	adr		x0, pfnode
	mov		x1, x19
	ldr		x2, [x19], #4
	ldr		x3, [x19], #4
	ldr		x4, [x19], #8
	ldr		x5, [x19], #8
	bl		printf

	add		x23, x23, #1
	mov		x19, x4
	cmp		x23, #3
	b.le	Compile_loop


	mov		X0, #0
	mov		x1, x20
	RESTORE
	ret

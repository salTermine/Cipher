##############################################################
# Do NOT modify this file.
# This file is NOT part of your homework 2 submission.
##############################################################

.data
str_input: .asciiz "Input: "
str_result: .asciiz "Result: "

# toUpper
toUpper_header: .asciiz "\n\n********* toUpper *********\n"
toUpper_Hi: .asciiz "Hi"

# countChars
countChars_header: .asciiz "\n\n********* countChars *********\n"
countChars_CSisFun: .asciiz "Computer Science is fun."
countChars_Terminator: .asciiz "I'll be back!!!!!!!!!"

# toLower
toLower_header: .asciiz "\n\n********* toLower *********\n"
toLower_Alphabet: .asciiz "ABCDeFGHIjkLMNoPQRstuvWXyZ"


# decodeNull
decodeNull_header: .asciiz "\n\n********* decodeNull *********\n"
decodeNull_text: .asciiz "Whenever students program lovely code very late at night, my brain explodes! *sigh sigh sigh*"
decodeNull_buffer: .space 101
.align 2
decodeNull_length: .word 100
decodeNull_pattern: .word 1, 5, 0, 5, 2, 1, 4, 0, 0, 1, 4, 3, 1, -1

# genBacon
genBacon_header: .asciiz "\n\n********* genBacon *********\n"
genBacon_plaintext1: .asciiz "Cse220!"
genBacon_buffer1: .space 25
		  .byte '\0'
genBacon_plaintext2: .asciiz "FALL is here."
genBacon_buffer2: .space 100

# hideEncoding
hideEncoding_header: .asciiz "\n\n********* hideEncoding *********\n"
hideEncoding_baconEncoding: .asciiz "BABBAAABAABBABAABABBABBBABABABAABAABBABAABBAAABAAAABBBBBAABABBBBB"
hideEncoding_text: .asciiz "Whenever students program lovely code very late at night, my brain explodes! *sigh sigh sigh*"

# findEncoding
findEncoding_header: .asciiz "\n\n********* findEncoding *********\n"
findEncoding_baconEncoding: .space 101
findEncoding_text: .asciiz "WhENeveR stUDeNts PrOGrAM LoVeLy CodE veRY  lAte At nigHt, my bRAIN ExpLoDES! *SIgh sigh sigh*"


# decodeBacon
decodeBacon_header: .asciiz "\n\n********* decodeBacon *********\n"
decodeBacon_baconEncoding: .asciiz "BABBAAABAABBABAABABBABBBABABABAABAABBABAABBAAABAAAABBBBBAABABBBBBAAAAAAAAAA"
decodeBacon_text: .space 101


# Constants
.eqv QUIT 10
.eqv PRINT_STRING 4
.eqv PRINT_INT 1
.eqv NULL 0x0

.macro print_string(%address)
	li $v0, PRINT_STRING
	la $a0, %address
	syscall 
.end_macro

.macro print_string_reg(%reg)
	li $v0, PRINT_STRING
	la $a0, 0(%reg)
	syscall 
.end_macro

.macro print_newline
	li $v0, 11
	li $a0, '\n'
	syscall 
.end_macro

.macro print_space
	li $v0, 11
	li $a0, ' '
	syscall 
.end_macro

.macro print_int(%register)
	li $v0, 1
	add $a0, $zero, %register
	syscall
.end_macro

.macro print_char_addr(%address)
	li $v0, 11
	lb $a0, %address
	syscall
.end_macro

.macro print_char_reg(%reg)
	li $v0, 11
	move $a0, %reg
	syscall
.end_macro

.text
.globl main

main:

	# TEST CASE for toUpper	
	print_string(toUpper_header)
	print_string(str_input)
	print_char_addr(toUpper_Hi)
	print_newline

	lb $a0, toUpper_Hi
	jal toUpper

	move $t0, $v0
	print_string(str_result)	
	print_char_reg($t0)
	print_newline

	print_string(str_input)
	la $t1, toUpper_Hi
	addi $t1, $t1, 1
	print_string_reg($t1)
	print_newline

	lb $a0, toUpper_Hi + 1
	jal toUpper

	move $t0, $v0
	print_string(str_result)
	print_char_reg($t0)
	print_newline

	# TEST CASE for countChars
	print_string(countChars_header)
	print_string(str_input)
	print_string(countChars_CSisFun)
	print_newline

	la $a0, countChars_CSisFun
	jal countChars

	move $t0, $v0
	print_string(str_result)
	print_int($t0)
	print_newline

	print_string(str_input)
	print_string(countChars_Terminator)
	print_newline

	la $a0, countChars_Terminator
	jal countChars

	move $t0, $v0
	print_string(str_result)
	print_int($t0)
	print_newline

	# TEST CASE for toLower
	print_string(toLower_header)
	print_string(str_input)
	print_string(toLower_Alphabet)
	print_newline

	la $a0, toLower_Alphabet
	jal toLower

	move $t0, $v0
	print_string(str_result)
	print_string_reg($t0)
	print_newline

	#  TEST CASE for decodeNull
	print_string(decodeNull_header)
	print_string(str_input)
	print_string(decodeNull_text)
	print_newline
	print_string(str_input)
	print_string(decodeNull_buffer)
	print_newline
	print_string(str_input)
	lw $t9, decodeNull_length
	print_int($t9)
	print_newline
	print_string(str_input)
	
	la $s0, decodeNull_pattern
	li $s1, 14
	add $s2, $0, $0

decodeNull_Loop:
	beq $s2, $s1, decodeNull_Done
	lw $t9, 0($s0)
	print_int($t9)
	print_space
	addi $s0, $s0, 4
	addi $s2, $s2, 1
	j decodeNull_Loop
	
decodeNull_Done:	
	print_newline
	la $a0, decodeNull_text
	la $a1, decodeNull_buffer
	lw $a2, decodeNull_length
	la $a3, decodeNull_pattern
	jal decodeNull

	print_string(str_result)
	print_string(decodeNull_buffer)
	print_newline

	#  TEST CASE for genBacon
	print_string(genBacon_header)
	print_string(str_input)
	print_string(genBacon_plaintext1)
	print_newline
	print_string(str_input)
	li $t9, 'V'
	print_char_reg($t9)
	print_newline
	print_string(str_input)
	li $t9, 112
	print_char_reg($t9)
	print_newline

	la $a0, genBacon_plaintext1
	la $a1, genBacon_buffer1
	li $a2, 'V'
	li $a3, 112
	jal genBacon

	move $t0, $v0
	move $t1, $v1
	print_string(str_result)
	print_string_reg($t0)
	print_newline

	print_string(str_result)
	print_int($t1)
	print_newline
	print_newline

	print_string(str_input)
	print_string(genBacon_plaintext2)
	print_newline
	print_string(str_input)
	li $t9, 0x7a
	print_char_reg($t9)
	print_newline
	print_string(str_input)
	li $t9, 0x0000000050
	print_char_reg($t9)
	print_newline



	la $a0, genBacon_plaintext2
	la $a1, genBacon_buffer2
	li $a2, 0x7a
	li $a3, 0x0000000050
	jal genBacon

	move $t0, $v0
	move $t1, $v1
	print_string(str_result)
	print_string_reg($t0)
	print_newline

	print_string(str_result)
	print_int($t1)
	print_newline

	#  TEST CASE for hideEncoding
	print_string(hideEncoding_header)
	print_string(str_input)
	print_string(hideEncoding_baconEncoding)
	print_newline
	
	print_string(str_input)
	print_string(hideEncoding_text)
	print_newline

	print_string(str_input)
	li $t9, 'B'
	print_char_reg($t9)
	print_newline
	print_string(str_input)
	li $t9, 65
	print_char_reg($t9)
	print_newline


	la $a0, hideEncoding_baconEncoding
	la $a1, hideEncoding_text
	li $a2, 'B'
	li $a3, 65
	jal hideEncoding
	move $t1, $v0
	add $t2, $v1, $0
	print_string(str_result)
	print_int($t1)
	print_newline
	print_string(str_result)
	print_int($t2)
	print_newline
	print_string(str_result)
	print_string(hideEncoding_text)
	print_newline

	#  TEST CASE for findEncoding
	print_string(findEncoding_header)
	print_string(str_input)
	print_string(findEncoding_text)
	print_newline
	print_string(str_input)
	li $t9, 'B'
	print_char_reg($t9)
	print_newline
	print_string(str_input)
	li $t9, 100
	print_int($t9)
	print_newline

	la $a0, findEncoding_baconEncoding
	la $a1, findEncoding_text
	li $a2, 'B'
	li $a3, 100
	jal findEncoding
	move $t1, $v0
	add $t2, $v1, $0
	print_string(str_result)
	print_int($t1)
	print_newline
	print_string(str_result)
	print_int($t2)
	print_newline
	print_string(str_result)
	print_string(findEncoding_baconEncoding)
	print_newline

	#  TEST CASE for decodeBacon
	print_string(decodeBacon_header)
	print_string(str_input)
	print_string(decodeBacon_baconEncoding)
	print_newline
	print_string(str_input)
	li $t9, 'B'
	print_char_reg($t9)
	print_newline
	print_string(str_input)
	li $t9, 100
	print_int($t9)
	print_newline	

	la $a0, decodeBacon_baconEncoding
	li $a1, 'B'
	la $a2, decodeBacon_text
	li $a3, 100
	jal decodeBacon
	move $t1, $v0
	add $t2, $v1, $0
	print_string(str_result)
	print_int($t1)
	print_newline
	print_string(str_result)
	print_int($t2)
	print_newline
	print_string(str_result)
	print_string(decodeBacon_text)
	print_newline


	# QUIT Program
quit_main:
	li $v0, QUIT
	syscall



#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw2.asm"

###################################################################
# Homework #2
# name: SALVATORE TERMINE
# sbuid: 109528463
###################################################################
.text

########################## TO UPPER ###############################
toUpper:
	move $t0, $a0		# Move $a0 to $t0
	bge $t0,0x61,lower	# If $t0 is greater then 0x61 -> a 
	j done			# Otherwise letter jump to done
  lower:
  	bge $t0,0x7a,done	# Upper bound for lowercase letters z
  	xori $t0,$t0,0x20 	# XOR with 32 to switch to uppercase
   done:
   	move $v0,$t0		# Move $t0 to $v0
	jr $ra			# Jump back to main program
######################## COUNT CHARS ##############################
countChars:
	la $t0,($a0)		# Load address $a0 into $t0
	li $t2,0		# Zero out t2
   loop:
   	lb $t1,($t0)		# Load bit from t0 into t1
   	beq $t1,0x0,done1	# If char is a null char then exit
   	beq $t1,0x20,skip	# If char is a space skip it
   	beq $t1,0x2e,done1	# If char is a period skip it
   	beq $t1,0x27,skip 	# If char is an apostrophy skip it
   	beq $t1,0x21,skip	# If char is an exclamtion skip it
   	addi $t2,$t2,1		# Increment char count
   skip:
   	addi $t0,$t0,1		# Increment to next char in t0
   	j loop			# Do it all over again
   done1:
   	move $v0,$t2		# Move the value to v0 to send back
	jr $ra			# Jump back to main
######################## TO LOWER  #################################
toLower:
	la $t0,($a0)		# Load address of a0 to t0
  loop1:
	lb $t1,($t0)		# Load bit into t1
	beq $t1,0x0,done2	# If null char exit
	blt $t1,0x41,next	# If symbol jump to next
	ble $t1,0x5a,upper	# If uppercase jump to upper
	bge $t1,0x61,next	# If lowercase jump to next
  upper:
  	blt $t1,0x41,next
  	xori $t1,$t1,0x20	# Otherwise XOR with 32
  	sb $t1,0($t0)		# Store the bit in t0
   next:
  	addi $t0,$t0,1		# Move to next bit
  	j loop1			# Do it again
   done2:
   	move $v0,$a0		# Load a0 into v0
	jr $ra			# Jump back to main
######################## DECODENULL ##############################
decodeNull:
	la $t0,($a0)		# Text
	la $t1,($a1)		# Buffer
	la $t3,0($a3)		# Pattern
	li $t6,1		# Counter
findChar:
	lb $t4,0($t0)		# Load the first letter into t4
	lw $t5,0($t3)		# Load the pattern #
	beq $t5,-1,done3	# If t5 = -1 pattern is done
	beq $t5,0,nextWord	# If t5 = 0 skip this word
	beq $t4,0x2a,skipChar	# If t5 = * skip
	beq $t4,0x2c,skipChar	# If t5 = , skip
	beq $t4,0x21,skipChar	# If t5 = ! skip
	beq $t5,$t6,foundChar	# Char is found
	addi $t0,$t0,1		# Otherwise move to next letter
	addi $t6,$t6,1		# increase counter
	j findChar		# Do it again
skipChar:
   	addi $t0,$t0,1		# Move to next char in string
   	j findChar		# Jump back to findChar
foundChar:
	addi $sp,$sp,-32	# Adjust stack pointer
	sw $t0,0($sp)		# Save current t registers
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $ra,28($sp)
	move $a0,$t4		# Move t4 to a0
	jal toUpper		# Call toupper
	sb $v0,0($t1)		# Store char in buffer
	lw $ra,28($sp)		# Restore registers
	lw $t6,24($sp)
	lw $t5,20($sp)
	lw $t4,16($sp)
	lw $t3,12($sp)
	lw $t2,8($sp)
	lw $t1,4($sp)
	lw $t0,0($sp)
	addi $sp, $sp,32	# Restore stack
	addi $t1,$t1,1		# Move to next byte in buffer
	j nextWord		# Jump to set up
nextWord: 
	addi $t0,$t0,1		# loop till end of word
	lb $t4,0($t0)		# Load char to check
	beq $t4,0x20,setup	# Space = end of word go to setup
	beq $t4,0x0,done3	# If null exit
	j nextWord		# Do it again
   setup:
   	li $t6,1		# Reset counter
   	addi $t0,$t0,1		# Move to next char in string
   	addi $t3,$t3,4		# Move to next number in pattern
   	j findChar		# Jump to findchar
  done3:
  	move $v0,$t1		# Move result to $v0
	jr $ra			# Jumb to main
	
###################################################################
# PART 2 FUNCTIONS
###################################################################

genBacon:
	move $t0,$a0 		# Input String
	move $t1,$a1		# Buffer
	move $t8,$a1		# Buffer start
	move $t2,$a2		# Symbol 1
	move $t3,$a3		# Symbol 2
	
	addi $sp,$sp,-20	# Store Current $T registers to stack
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $ra,16($sp)
	
	move $a0,$t0		# Save argument
	jal toLower		# Go toLower
	
	lw $t0,0($sp)		# Restore Registers
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $ra,16($sp)
	addi $sp,$sp,20
	
	move $t0,$v0		# Move return value to t0
encode:
	lb $t4,0($t0)		# Load first char
	li $t5,0x10		# Use 16 to start and
	beq $t4,0x0,eom
	beq $t4,0x20,spaceSetup
	beq $t4,0x21,excSetup
	beq $t4,0x27,aposSetup
	beq $t4,0x2c,comSetup
	beq $t4,0x2e,perSetup
	beq $t4,0x30,number
	beqz $t4,eom
	
number:
	ble $t4,0x39,charFin
	
	addi $t4,$t4,-1		# Subtract 1
	li $t5,0x10		# Use 16 to start and
	
	charSetup:
		 and $t6,$t4,$t5
		 beqz $t5,charFin	
		 beq $t6,0,sym1	
		 bgtz $t6,sym2	
	    sym1:
	    	 sb $t2,0($t1)
	    	 addi $t1,$t1,1
	    	 srl $t5,$t5,1
	    	 j charSetup	
	    sym2:
	    	 sb $t3,0($t1)
	    	 addi $t1,$t1,1
	    	 srl $t5,$t5,1
	    	 j charSetup
	charFin:
		addi $t0,$t0,1
		j encode
	
	spaceSetup:
		addi $t4,$t4,-6
		and $t6,$t4,$t5
		beqz $t5,charFin
		beq $t6,0,symb1
		bgtz $t6,symb2
	   symb1:
	    	sb $t2,0($t1)
	    	addi $t1,$t1,1
	    	srl $t5,$t5,1
	    	j spaceSetup	
	   symb2:
	    	sb $t3,0($t1)
	    	addi $t1,$t1,1
	    	srl $t5,$t5,1
		j spaceSetup

	excSetup:
		addi $t4,$t4,-6
		and $t6,$t4,$t5
		beqz $t5,excFin
		beq $t6,0,exec1
		bgtz $t6,exec2
	   exec1:
	    	sb $t2,0($t1)
	    	addi $t1,$t1,1
	    	srl $t5,$t5,1
	    	j excSetup	
	   exec2:
	    	sb $t3,0($t1)
	    	addi $t1,$t1,1
	    	srl $t5,$t5,1
		j excSetup
	  excFin:
		addi $t0,$t0,1
		j encode

	aposSetup:
		addi $t4,$t4,-6
		and $t6,$t4,$t5
		beqz $t5,charFin
		beq $t6,0,symbol1
		bgtz $t6,symbol2
	   symbol1:
	    	sb $t2,0($t1)
	    	addi $t1,$t1,1
	    	srl $t5,$t5,1
	    	j aposSetup	
	   symbol2:
	    	sb $t3,0($t1)
	    	addi $t1,$t1,1
	    	srl $t5,$t5,1
		j aposSetup
		
	comSetup:
		addi $t4,$t4,-6
		and $t6,$t4,$t5
		beqz $t5,charFin
		beq $t6,0,symbol3
		bgtz $t6,symbol4
	   symbol3:
	    	sb $t2,0($t1)
	    	addi $t1,$t1,1
	    	srl $t5,$t5,1
	    	j comSetup	
	   symbol4:
	    	sb $t3,0($t1)
	    	addi $t1,$t1,1
	    	srl $t5,$t5,1
		j comSetup
		
	perSetup:
		addi $t4,$t4,-6
		and $t6,$t4,$t5
		beqz $t5,charFin
		beq $t6,0,symbol5
		bgtz $t6,symbol6
	   symbol5:
	    	sb $t2,0($t1)
	    	addi $t1,$t1,1
	    	srl $t5,$t5,1
	    	j perSetup	
	   symbol6:
	    	sb $t3,0($t1)
	    	addi $t1,$t1,1
	    	srl $t5,$t5,1
		j perSetup
	eom:	
		not $t4,$t4
		and $t6,$t4,$t5
		beqz $t5,eomFin		
		bgtz $t6,eom1	
	eom1:
		sb $t3,0($t1)
		addi $t1,$t1,1
		srl $t5,$t5,1
		j eom	    
	eomFin:
		addi $t0,$t0,1
		j goback				
			
goback:	
	
	addi $sp,$sp,-24	# Store Current $T registers to stack
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t8,16($sp)
	sw $ra,20($sp)
	
	move $a0,$t0		# Save argument
	jal countChars		# Go toLower
	
	lw $t0,0($sp)		# Restore Registers
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t8,16($sp)
	lw $ra,20($sp)
	addi $sp,$sp,24
	
	move $t7,$v0
	move $v1,$t7
	move $v0,$t8
	jr $ra

hideEncoding:
	move $t0,$a0	# Baconian Text
	move $t1,$a1	# Text
	move $t2,$a2	# Sym1
	move $t3,$a3	# Sym2
	move $t7,$zero
	
	addi $sp,$sp,-20	# Store Current $T registers to stack
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $ra,16($sp)
	
	move $a0,$t1		# Save argument
	jal toLower		# Go toLower
	
	lw $t0,0($sp)		# Restore Registers
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $ra,16($sp)
	addi $sp,$sp,20
	
	move $t1,$v0		# Move return value to t0
	
	addi $sp,$sp,-20	# Store Current $T registers to stack
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $ra,16($sp)
	move $a0,$t0
	jal countChars
	lw $t0,0($sp)		# Restore Registers
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $ra,16($sp)
	addi $sp,$sp,20
	move $t9,$v0

	addi $sp,$sp,-24	# Store Current $T registers to stack
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $ra,16($sp)
	sw $t9,20($sp)
	move $a0,$t1
	jal countChars
	lw $t0,0($sp)		# Restore Registers
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $ra,16($sp)
	lw $t9,20($sp)
	addi $sp,$sp,24
	move $t8,$v0	
hidden:
	bgt $t7,$t9,end
	lb $t4,0($t0)
	lb $t5,0($t1)
	beq $t5,0x20,skipSpace
	beq $t5,0x21,skipSpace
	beq $t5,0x27,skipSpace
	beq $t5,0x2c,skipSpace
	beq $t5,0x2e,skipSpace
	beq $t4,$t2,upperCase
	beq $t4,$t3,nextPlease
	beqz $t5,end
upperCase:
	bge $t4,0x5b,nextPlease
	addi $sp,$sp,-36	# Store Current $T registers to stack
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $ra,16($sp)
	sw $t7,20($sp)
	sw $t8,24($sp)
	sw $t9,28($sp)
	sw $t5,32($sp)
	move $a0,$t5		# Save argument
	jal toUpper		# Go toUpper
	
	lw $t0,0($sp)		# Restore Registers
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $ra,16($sp)
	lw $t7,20($sp)
	lw $t8,24($sp)
	lw $t9,28($sp)
	lw $t5,32($sp)
	addi $sp,$sp,36
	move $t5,$v0		# Move return value to t0
	j nextPlease
nextPlease:
	sb $t5,0($t1)
	addi $t0,$t0,1
	addi $t1,$t1,1
	addi $t7,$t7,1
	j hidden
skipSpace:
	sb $t5,0($t1)
	addi $t1,$t1,1
	j hidden
end:

	move $v0,$t1
	ble $t9,$t8,false
	bgt $t9,$t8,true
true:
	li $v1,1
	jr $ra
false:
	li $v1,0
	jr $ra
################################################################
findEncoding:
	move $t0,$a0 		# buffer
	move $t5,$zero
	move $t5,$a0
	move $t1,$a1 		# findEncoding_text
	move $t2,$a2		# 'B'
	move $t3,$a3		# 100
	
findCode:
	lb $t4,0($t1)
	beqz $t4,nextstep
	beq $t4,0x20,skipThis
	beq $t4,0x21,skipThis
	beq $t4,0x27,skipThis
	beq $t4,0x2c,skipThis
	beq $t4,0x2e,skipThis
	ble $t4,0x5a,itsUpper
	ble $t4,0x7a,itsLower
	
itsUpper:
	blt $t4,0x41,skipThis
	sb $t2,0($t0)
	addi $t0,$t0,1
	addi $t1,$t1,1
	j findCode
itsLower:
	blt $t4,0x61,skipThis
	sb $t3,0($t0)
	addi $t0,$t0,1
	addi $t1,$t1,1
	j findCode
skipThis:
	addi $t1,$t1,1
	j findCode
	
nextstep:
	move $t6,$t5
convert:
	lb $t7,0($t6)
	move $v0,$t7
	jr $ra
	
	
zero: 
	
	
	
	
	
	
	
	










decodeBacon:
	#Define your code here
	jr $ra


.data

.align 2 

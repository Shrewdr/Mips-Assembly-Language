##########################################
#   Author : Mr. BlackCrow               #
##########################################

.data 

welcomeString: .asciiz "* Welcome to The quadratic equation solver 'QES' !\n* We compute the roots of a quadratic for you in Assembly!\nTo begin please provide a,b and c (i.e. from ax^2 + bx +c =0 , a!=0):\n"

String_FirstValue:  .asciiz "\n\nThe first root is is composed of two parts\n"
String_SecondValue: .asciiz "\n\nThe second root is is composed of two parts \n"
String_Answer: .asciiz "\n\nThe only one root is composed of two parts : \n"

String_real: .asciiz "\n  > Its real part is = "
String_imginary_no: .asciiz "  > Its imiginary part is = 0.0i "
String_imginary: .asciiz "  > Its imiginary part is = "
String_i: .asciiz "i"

String_dist_Output: .asciiz "\n*There are two distinct real roots!"
String_dupl_Output: .asciiz "\n*There are duplicate real roots!"
String_complx_Output: .asciiz "\n*There are two distinct complex roots!"

newLine : .asciiz "\n"
.text

main: #------------------------------>
	la $a0 , welcomeString #
	li $v0 , 4		 #  Welcoming the user by a String 	syscall		 # 
	syscall

	li $v0,5 	      # -- 1
	syscall          # getting "a" and saving it in $a0 
	move $a0 , $v0   #

	li $v0,5 	      # -- 2
	syscall          # getting "b" and saving it in $a1 
	move $a1 , $v0   #

	li $v0,5 	      # -- 3
	syscall          # getting "c" and saving it in $a2 
	move $a2 , $v0   #

	jal roots # this procedure computes the roots
	# roots give output
roots_output_check:
	# answers are in $f0-$f7
	# -1 if $f4 to $f8 are not zeros the answer is complex
	c.eq.d 0,$f4,$f6 # if not equal either is non-zero value
	bc1f 0,complex_Output # brach if they arn't equal
	
	move $t0 , $zero      # prepare Zero for co-p1
	mtc1 $t0 , $f8        # move Zero to co-p1
	cvt.d.w $f8 , $f8     # converting Zero to double
	
	c.eq.d 0,$f4 , $f8 # check if complex  $f4 reg  is Zero
	c.eq.d 1,$f6 , $f8 # check if complex  $f6 reg  is Zero
	
	bc1f 0,complex_Output # if not zero answer is complex
	bc1f 1,complex_Output # if not zero answer is complex
	
	#else answer is either dublicates or disticts real nums 
	
	beqz , $s1,dublicate_Output # $s1 is changed in "roots" label
	
	#else answer is two distict real nums
	distinct_Output:
	
		la $a0 ,String_dist_Output#
		li $v0 , 4 #  printing a friendly string
		syscall#
		
		la $a0 , String_FirstValue#
		syscall #  printing a friendly string
		
		la $a0 , String_imginary_no # 0i
		syscall #  printing imiginary part String
	
		la $a0 , String_real
		syscall # String > printing real part txt
		
		mov.d $f12 , $f0 # moving answer 1 to $f12
		li $v0 , 3	      # ($f0 modified in roots)
		syscall 	      # Printing answer 1
		
		
		       #
		la $a0 , String_SecondValue# answer 2
		li $v0 , 4
		syscall #  printing a friendly string
		
		la $a0 , String_imginary_no # 0i
		syscall #  printing imiginary part String
		
		
		la $a0 , String_real
		syscall #  printing real part String
		
		mov.d $f12 , $f2 # moving answer 1 to $f12
		li $v0 , 3	      # ($f2 modified in "roots")
		syscall	      # Printing answer 2
		
		# extra code ? y
	
		j continue_Main   #skip additianl branches
		
		
	dublicate_Output:
		
		la $a0 ,String_dupl_Output#
		li $v0 , 4 # 
		syscall    # printing a friendly string
		
		la $a0 , String_Answer#
		syscall #  printing a friendly string
		
		la $a0 , String_imginary_no # "0i"
		syscall #  printing imiginary part String
		la $a0 , String_real
		syscall #  printing real part String
		
		
		mov.d $f12 , $f0 # moving the answer to $f12
		li $v0 , 3	      # ($f0 modified in roots)
		syscall 	      # print the answer
		
		# exrta code ? mb
		
	j continue_Main   #skip additianl branch
	
	
	
	complex_Output:
		# some code goes here
		
		la $a0 ,String_complx_Output#
		li $v0 , 4 # 
		syscall    # printing a friendly string
		
		################ first num ##############
		la $a0 , String_FirstValue# answer 1
		syscall #  printing a friendly string
		
		la $a0 , String_imginary # 
		syscall #  printing imiginary part String
		
		mov.d $f12 , $f4 # first imiginary part of fist number
		li $v0 ,3 	      #
		syscall          #
		
		la $a0  ,String_i  # i
		li $v0 ,4          #
		syscall            #
		
		
		la $a0 , String_real
		syscall #  printing real String
		
		
		mov.d $f12 , $f0 # moving the answer to $f12
		li $v0 , 3	      # ($f0 modified in roots)
		syscall 	      # print the answer
		
		############## second num #############
		la $a0 , String_SecondValue# answer 2
		li $v0 ,4
		syscall #  printing a friendly string
		
		la $a0 , String_imginary # 
		syscall #  printing imiginary part String
		
		mov.d $f12 , $f6 # first imiginary part of fist number
		li $v0 ,3 
		syscall
		
		la $a0  ,String_i  # i
		li $v0 ,4          #
		syscall            #
		
		
		la $a0 , String_real
		syscall #  String > printing real txt 
		
		
		mov.d $f12 , $f0 # moving the answer to $f12
		li $v0 , 3	      # ($f0 modified in roots)
		syscall 	      # print the answer
	
		
		# The end of complex_output
		
continue_Main: 
# future code may be here .
 j Exit
 #End of main ----------------------<

roots:
   	#real part of the roots in the ($f1$f0) and the ($f3$f2) pairs
	# imagenary part in the ($f5$f4) and the ($f7$f6) pairs
	# we first compute the discriminant b^2 - 4ac

	mulo $t1,$a1,$a1    # b^2 and move to $t1
	mulo $t2,$a0,$a2   # a*c and move to $t2
		sll $t2 , $t2 ,2    # $t2 = 4ac
	sub $s0 , $t1 , $t2 # $t3 = b^2 - 4ac


	bgt $s0 , $zero , PositiveDicr # branch if positive discriminant
	blt $s0 , $zero , NegativeDicr # branch if negative discriminant

# else $t3 = 0 > Zero
ZeroDicr: 
	li $s1 , 0 # to indicate having to dublicate roots

	move $t1 , $a1 	 # prepare moving b to co-p1
	subu $t1 , $zero , $t1 # b > negation > -b
	mtc1 $t1 , $f8	 # moving b to a double reg
	cvt.d.w $f8 , $f8      # convert b to double
	
	sll $t0 , $a0 ,1  # 2*a and prepare moving 2a to a co-p1
	mtc1 $t0 , $f6    # moving a to a double reg
	cvt.d.w $f6 , $f6 # convert a to double
	
	div.d $f0 , $f8 , $f6 # -b/2a
	
	 
	
  # the following is to make sure $f6,$f5,$f4,$f3 are Zeros
	move $t0 , $zero # prepare moving Zero to co-p1
	mtc1 $t0 , $f4   # moving Zero to co-p1
	cvt.d.s $f4, $f4 # convert Zero to double in $f4
	mov.d $f6 , $f4   # moving Zero to $f6 
	
	#This is the end of part 0
	
	j continue # skip other branches

PositiveDicr: # ----- ----- ----- { 
	li $s1 , 1 # to indicate having to distinct roots

	move $t0 , $s0     # prepare moving Dicr to co-p1
	mtc1.d $t0 , $f8   # Dicr moved to $f8
	cvt.d.w $f8 , $f8  # convert Dicr to double
#
	sqrt.d $f8 , $f8   # square root of Dicr 
#
	move $t0, $a1      # prepare "b" for co-p1 
	mtc1.d $t0 , $f6   # "b" moved to $f6
	cvt.d.w $f6 , $f6  # convert $f6 to double
	
	sub.d $f0, $f8, $f6 #Dicr - b 
	
	move $t0 , $zero #
	mtc1 $t0 , $f10#
	cvt.d.w $f10 , $f10 # put zero in $f10
	sub.d $f8 , $f10, $f8 # negate Dicr
	
	sub.d $f2, $f8, $f6 #-Dicr - b 
	
	sll $t0 , $a0 , 1  # a*2 
	mtc1.d $t0 , $f4   # 2a moved to $f4
	cvt.d.w $f4 , $f4  # convert 2a to double
#
	
	div.d $f0,$f0,$f4 # (sqrt(Dicr)-b)/2a > answer 1
	div.d $f2,$f2,$f4 # (-sqrt(Dicr)-b)/2a > answer 2
	
	# the following is to make sure $f6,$f5,$f4,$f3 are Zeros
	move $t0 , $zero # prepare moving Zero to co-p1
	mtc1 $t0 , $f4   # moving Zero to co-p1
	cvt.d.s $f4, $f4 # convert Zero to double in $f4
	mov.d  $f6 ,$f4  # moving Zero to $f6 %%%
	
	# The end of part1

j continue # }  skip other branches


NegativeDicr: # ----- ----- -----
	move $t1 , $a1 	 # prepare moving b to co-p1
	subu $t1 , $zero , $t1 # b > negation > -b
	mtc1 $t1 , $f8	 # moving b to a double reg
	cvt.d.w $f8 , $f8      # convert b to double
	
	sll $t0 , $a0 ,1  # 2*a and prepare moving 2a to a co-p1
	mtc1 $t0 , $f6    # moving a to a double reg
	cvt.d.w $f6 , $f6 # convert a to double
	
	div.d $f0 , $f8 , $f6 # -b/2a  > real part is done
	
	# imiginary part begins
	
	sub $t0 , $zero , $s0 # making Dicr positive -(-Dicr)
	mtc1 $t0 , $f4 # move to co-p1
	cvt.d.w $f4,$f4 # convert Dicr to double 
	sqrt.d $f4 ,$f4 # square root of Dicr 
	
	sll $t0 , $a0 ,1 # a*2 and store in $t0
	mtc1 $t0 , $f6 # move to co-p1
	cvt.d.w $f6,$f6 # convert a*2 to double 
	
	div.d $f4,$f4,$f6 #  sqrt(Dicr)/2a < the first answer
	
	move $t0 , $zero # 
	mtc1 $t0 , $f8 # move zero to co-p1
	cvt.d.s $f8 , $f8 # convert to double
	sub.d  $f6 , $f8 , $f4 # < the second answer 
	

continue:# complete the roots flow ... 

jr $ra # retrun back to the caller -------- end of "roots"



Exit:	 #------------------------------
la $a0 , newLine	#
li $v0 , 4		#
syscall		# new Line

li $v0 ,10  # Properly terminating the program
syscall     #------------------------------


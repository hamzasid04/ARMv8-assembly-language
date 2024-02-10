
//Hamza Siddiqui
//hamza.siddiqui@ucalgary.ca
//UCID: 30183881
// TUT 02

 //This program implements a integer multiplication program

define(multiplier, w19)      // Define multiplier as w19, a 32-bit wide register
define(multiplicand, w20)    // Define multiplicand as w20, a 32-bit wide register
define(product, w21)         // Define product as w21, a 32-bit wide register to store the result of multiplication
define(i, w22)               // Define i as w22, a 32-bit wide register used for loop counter
define(negative, w23)        // Define negative as w23, a 32-bit wide register to indicate if the result should be negative

define(result, x19)          // Define result as x19, a 64-bit wide register to store the full multiplication result
define(temp1, x20)           // Define temp1 as x20, a 64-bit wide register used for temporary storage during calculations
define(temp2, x21)           // Define temp2 as x21, a 64-bit wide register used for temporary storage during calculations

define(product64, x23)       // Define product64 as x23, a 64-bit wide register to store the extended product result
define(multiplier64, x24)    // Define multiplier64 as x24, a 64-bit wide register to store the extended multiplier value

define(TRUE,1)               // Define TRUE as a constant value 1, used for boolean true condition
define(FALSE,0)              // Define FALSE as a constant value 0, used for boolean false condition


initial_val: .string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n" //creates the format for 1st print statement
prod_multpier_val: .string "product = 0x%08x multiplier = 0x%08x\n"  //creates the format for 2nd print statement
print_result: .string "64-bit result = 0x%016lx (%ld)\n"  //creates the format for 3rd print statement
        .balign 4
        .global main            //makes "main" linker visible to linker and is routine and boilerplate where execution starts

main: stp x29, x30, [sp, -16]!  //allocates 16 bytes in RAM
                                //also stores content of x29 frame pointer and x30 link register to RAM
        mov x29, sp

        //Initialize variables
        mov multiplicand, -252645136     // Set multiplicand to -252645136
        mov multiplier, -256             // Set multiplier to -256
        mov product, 0                  // Set product to 0

print_initial:
        adrp x0, initial_val    // Get address of initial_val format string
        add x0, x0, :lo12: initial_val  // Add the lower 12 bits of the address to x0

        mov w1, multiplier      // move multiplier value into w1 register
        mov w2, multiplier      // move multiplier value into w2 register
        mov w3, multiplicand    // move multiplier value into w3 register
        mov w4, multiplicand    // move multiplier value into w4 register
        bl printf               // call printf function and print initialv values

negative_or_not:
        mov i, 0                                //Initialize i here
        cmp multiplier,0                        // Compare multiplier to 0
        b.ge multiplierIsNotNegative            //If multiplier is greater or equal to 0, branch to multiplierIsNotNegative
        mov negative, TRUE                      //If multiplier is negative, set negative flag to TRUE
        b initial_loop                          //Branch to the start of the loop
multiplierIsNotNegative: mov negative, FALSE            // If multiplier is not negative, set negative flag to FALSE
initial_loop:
        cmp i, 32               // Compare loop counter i to 32
        b.ge adjust_negative    // If i is greater or equal to 32, branch to adjust_negative
        b compare1              // Otherwise, branch to compare1
compare1:
        tst multiplier, 0x1     // Test least significant bit of multiplier
        b.eq compare2           // Test and statement. If result of AND stmt. eq to 0, branch to productIsFalse. If not then continue with the code below.

step1:
        add product,product, multiplicand       // Add multiplicand to product if least significant bit of multiplier is 1

compare2:
        asr multiplier, multiplier, 1           // Arithmetic shift right multiplier by 1
        tst product, 0x1                        // Test and statement. If result of AND stmt. eq to 0, branch to productIsFalse. If not then continue with the code below
        b.eq productIsFalse                     // If least significant bit of product is 0, branch to productIsFalse
        orr multiplier, multiplier, 0x80000000  // Set the most significant bit of multiplier
        b step2         //Imp to go to branch step2 or else it will go to else statement below to ProdIsFalse
productIsFalse: //else statement
        and multiplier, multiplier, 0x7fffffff  // Clear most significant bit of multiplier if product's least significant bit is 0

step2:
        asr product, product, 1         // Arithmetic shift right product by 1
        add i, i, 1                     //Increment the i for the loop
        b initial_loop                  // Branch back to the beginning of the loop
adjust_negative:
        cmp negative, TRUE                      // Compare negative flag to TRUE
        b.ne print_prod_multpier                // If negative flag is not set, branch to print_prod_multpier
        sub product, product, multiplicand      // Subtract multiplicand from product

print_prod_multpier:
        adrp x0, prod_multpier_val              // Load address of prod_multpier_val format string
        add x0, x0, :lo12: prod_multpier_val    // Add offset to get the exact address

        mov w1, product                         // Move the product value into w1, to be used as the first argument for printf
        mov w2, multiplier                      // Move the multiplier value into w2, to be used as the second argument for printf

        bl printf                               // Branch with link to printf, which will print the product and multiplier

combineProdMultplier:
        sxtw product64, product                 // Convert 32-bit product value to 64-bit value and store it in product64
        and temp1, product64, 0xffffffff        // Perform a bitwise AND with product64 and 0xffffffff, store result in temp1
        lsl temp1, temp1, 32                    // Logical shift left temp1 by 32 bits to position the product correctly
        sxtw multiplier64, multiplier           // Convert 32-bit multiplier value to 64-bit value and store it in multiplier64
        and temp2, multiplier64, 0xffffffff     // Perform a bitwise AND with multiplier64 and 0xffffffff, store result in temp2

        add result, temp1, temp2                // Add temp1 and temp2 to combine the 64-bit product and multiplier, store in result
        //printing out all 64 bit results
        adrp x0, print_result                   // Load the page address of the print_result format string into x0
        add x0, x0, :lo12: print_result         // Add the lower 12 bits of the address to get the full address of print_result

        mov x1, result                          // Move the 64-bit result into x1, to be used as the first argument for printf
        mov x2, result                          // Move the 64-bit result into x2, to be used as the second argument for printf
        bl printf                               // Branch with link to printf, which will print the 64-bit result

end:
        mov w0, 0                       // restoring regsiters to 0 (return 0)
        ldp     x29, x30, [sp], 16      // Load the frame pointer and link register back from the stack, and deallocate the stack space
        ret                             // Return to caller    

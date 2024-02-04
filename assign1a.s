


// Hamza Siddiqui
// hamza.siddiqui@ucalgary.ca
//UCID: 30183881
// TUT 02

fmt: .string "x = %d, y = %d, current min y = %d\n" //creates the format strin
//fmt: .string " Min y value found %d at x = %d\n"
        .balign 4
        .global main            //makes "main" linker visible to linker and is routine and boilerplate where execution starts

main: stp x29, x30, [sp, -16]!  //allocates 16 bytes in RAM
                                //also stores content of x29 frame pointer and x30 link register to RAM
        mov x29, sp

        mov x21, -10            //assigning or moving variables to values
        mov x22, 4
        mov x23, 5000           //Will be Min value of Y. Assigned 5000 for strating if statemnt
        mov x19, x21            //Will be the current x .Assigns x to minimun value of X possible within the range given
        mov x20, 0              //will be the current y
        mov x25, 0              //temporary register
        mov x24, 0              // will be the x found for lowest value of y
test:
        cmp x19, 4
        b.gt end                // program will stop executing once x reaches maximum value of 4
        b calc          //go to calculations to continue
calc:   mov x20, 0      //y is reset to 0 just in case

        mov x25, 3              // 3*x^3 calulations
        mul x25, x25, x19
        mul x25, x25, x19
        mul x25, x25, x19
        add x20, x20, x25

        mov x25, 31             // 31*x^2 calculations
        mul x25, x25, x19
        mul x25, x25, x19
        add x20, x20, x25

        mov x25, -15            // -15x calculations
        mul x25, x25, x19
        add x20, x20, x25

        sub x20, x20, 127

        cmp x20, x23            // if newer y is less than prev. y, the prev. y (yMin) will be updated to have
                                        // lower y value to be stored
        b.lt update_y_min
        b printing              //continues to print regardless if y is updated or not
update_y_min:
        mov x23, x20    //min y found will be at x23
        mov x24, x19    // min x found that produces min y will be at x24


printing:                       // responsible for printing x and y and looping back to test.
        adrp x0, fmt
        add x0, x0, :lo12: fmt

        mov x1, x19     // x value display
        mov x2, x20     // y value display
        mov x3, x23     //min Y value display

        bl printf

        add x19, x19, 1         //increment x by 1
        b test          // return to test if loop must be repeated

end:    // ends the loop 
ldp     x29, x30, [sp], 16
        ret     // Return to caller

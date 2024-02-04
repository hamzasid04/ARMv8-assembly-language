
//Hamza Siddiqui
// hamza.siddiqui@ucalgary.ca
//UCID: 30183881
// TUT 02

define(x_r, x19)	//current x value from range
define(y_r, x20)	// current y value gotten
define(xMin, x21)	// x = -10 lowest value from range
define(xMax, x22)	// x = 4 highest vlaue from range
define(yMin, x23)	// lowest value of y found from equation
define(xfound, x24)	// the x value from range that gives us the lowest value of y 
define(temp, x25)	// temporary register used for adding

define(coef1, x26)	//x26: coefficient for the 1st term
define(coef2, x27)	// x27: coefficient for the 2nd term
define(coef3, x28)	// x28: coefficient for the 3rd term

fmt: .string "x = %d, y = %d, current min y = %d\n" //creates the format strin

        .balign 4
        .global main            //makes "main" linker visible to linker and is routine and boilerplate where execution starts

main: stp x29, x30, [sp, -16]!  //allocates 16 bytes in RAM
                                //also stores content of x29 frame pointer and x30 link register to RAM
        mov x29, sp

        mov xMin, -10            //assigning or moving variables to values
        mov xMax, 4
        mov yMin, 5000           //Will be Min value of Y. Assigned 5000 for strating if statemnt
        mov x_r, xMin            //Will be the current value of x .Initially will be Assigned x to minimun value of X possible within the range given
        mov y_r, 0              //will be the current y
        mov temp, 0              //temporary register
        mov xfound, 0              // will be the x found for lowest value of y

	mov coef1, 3		// coefficient for the 1st term
	mov coef2, 31		// coefficient for the 2nd term
	mov coef3, -15		// coefficient for the 3rd term
	
	b test
calc:   mov y_r, 0      //y is reset to 0 just in case
				// we use a temp. register so that it will put the final value into y without it having y to multiply with another c					coeffiecinet when it should be multiplying with x. Or else it will be the prev y value multiplying w						ith coef and x value
        mov temp, 0              // 3*x^3 calulations
        mul temp, coef1, x_r
        mul temp, temp, x_r
        madd y_r, temp, x_r,y_r

	mov temp, 0
        mul temp, coef2, x_r             // 31*x^2 calculations
        madd y_r, temp, x_r, y_r

        madd y_r, coef3, x_r, y_r            // -15x calculations

        sub y_r, y_r, 127			// subtracts 127 as last part of equation

        cmp y_r, yMin            // if newer y is less than prev. y, the prev. y (yMin) will be updated to have
                                        // lower y value to be stored
        b.lt update_y_min
        b printing              //continues to print regardless if y is updated or not
update_y_min:
        mov yMin, y_r    //min y found will be at x23
        mov xfound, x_r    // min x found that produces min y will be at x24


printing:                       // responsible for printing x and y and looping back to test.
        adrp x0, fmt
        add x0, x0, :lo12: fmt

        mov x1, x_r     // x value display
        mov x2, y_r     // y value display
        mov x3, yMin     //min Y value display

	bl printf

        add x_r, x_r, 1         //increment x by 1
        b test          // return to test if loop must be repeated

test:
        cmp x_r, 4
        b.gt end                // program will stop executing once x reaches maximum value of 4
        b calc          //go to calculations to continue

end:    
ldp     x29, x30, [sp], 16
        ret     // Return to caller

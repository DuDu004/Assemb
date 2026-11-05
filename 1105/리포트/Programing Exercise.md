Programming Exercises

1. FindLargest Procedure
   Create a procedure named FindLargest that receives two parameters: a pointer to a signed
   doubleword array, and a count of the array’s length. The procedure must return the value of
   the largest array member in EAX. Use the PROC directive with a parameter list when declaring the procedure. Preserve all registers (except EAX) that are modified by the procedure.
   Write a test program that calls FindLargest and passes three different arrays of different
   lengths. Be sure to include negative values in your arrays. Create a PROTO declaration for FindLargest.

2. Chess Board
   Write a program that draws an 8 X 8 chess board, with alternating gray and white squares.
   You can use the SetTextColor and Gotoxy procedures from the Irvine32 library. Avoid the use of global variables, and use declared parameters in all procedures. Use short procedures that are focused on a single task.

3. Chess Board with Alternating Colors
   This exercise extends Exercise 2. Every 500 milliseconds, change the color of the colored
   squares and redisplay the board. Continue until you have shown the board 16 times, using all
   possible 4-bit background colors. (The white squares remain white throughout.)

4. FindThrees Procedure
   Create a procedure named FindThrees that returns 1 if an array has three consecutive values of
   3 somewhere in the array. Otherwise, return 0. The procedure’s input parameter list contains a
   pointer to the array and the array’s size. Use the PROC directive with a parameter list when
   declaring the procedure. Preserve all registers (except EAX) that are modified by the procedure.
   Write a test program that calls FindThrees several times with different arrays.

5. DifferentInputs Procedure
   Write a procedure named DifferentInputs that returns EAX = 1 if the values of its three input
   parameters are all different; otherwise, return with EAX = 0. Use the PROC directive with a
   parameter list when declaring the procedure. Create a PROTO declaration for your procedure,
   and call it five times from a test program that passes different inputs.

6. Exchanging Integers
   Create an array of randomly ordered integers.
   Using the Swap procedure from Section 8.4.6 as a tool, write a loop that exchanges each consecutive pair of integers in the array.

7. Greatest Common Divisor
   Write a recursive implementation of Euclid’s algorithm for finding the greatest common divisor
   (GCD) of two integers. Descriptions of this algorithm are available in algebra books and on the
   Web. Write a test program that calls your GCD procedure five times, using the following pairs of
   integers: (5,20), (24,18), (11,7), (432,226), (26,13). After each procedure call, display the GCD.

8. Counting Matching Elements
   Write a procedure named CountMatches that receives points to two arrays of signed doublewords, and a third parameter that indicates the length of the two arrays. For each element xi in the first array, if the corresponding yi
   in the second array is equal, increment a count. At the end,
   return a count of the number of matching array elements in EAX. Write a test program that calls
   your procedure and passes pointers to two different pairs of arrays. Use the INVOKE statement
   to call your procedure and pass stack parameters. Create a PROTO declaration for CountMatches. Save and restore any registers (other than EAX) changed by your procedure.

9. Counting Nearly Matching Elements
   Write a procedure named CountNearMatches that receives pointers to two arrays of signed doublewords, a parameter that indicates the length of the two arrays, and a parameter that indicates the maximum allowed difference (called diff) between any two matching elements. For each element xi in the first array, if the difference between it and the corresponding yi in the second array is less than or equal to diff, increment a count. At the end, return a count of the number of nearly matching array elements in EAX. Write a test program that calls CountNearMatches and passes pointers to two different pairs of arrays. Use the INVOKE statement to call your procedure and pass stack parameters. Create a PROTO declaration for CountMatches. Save and restore any registers(other than EAX) changed by your procedure.

10. Show Procedure Parameters
    Write a procedure named ShowParams that displays the address and hexadecimal value of the
    32-bit parameters on the runtime stack of the procedure that called it. The parameters are to be
    displayed in order from the lowest address to the highest. Input to the procedure will be a single
    integer that indicates the number of parameters to display. For example, suppose the following
    statement in main calls MySample, passing three arguments:
    INVOKE MySample, 1234h, 5000h, 6543h
    Next, inside MySample, you should be able to call ShowParams, passing the number of parameters you want to display:
    MySample PROC first:DWORD, second:DWORD, third:DWORD
    paramCount = 3
    call ShowParams, paramCount
    ShowParams should display output in the following format:
    Stack parameters:
    ***
    Address 0012FF80 = 00001234
    Address 0012FF84 = 00005000
    Address 0012FF88 = 00006543

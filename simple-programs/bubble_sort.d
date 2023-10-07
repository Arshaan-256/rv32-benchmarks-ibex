# Bubble Sort.
# x1 - Base address of the array.
# x2 - (Outer loop variable) Stores the size of array, `ARR_BASE + (ARR_LEN-1)*4`. 
#      Every iteration of the outer loop, the variable is decremented by 4.
#      To account of the `size - step - 1`.
# x3, x4 - Variables to store array elements that are being compared.
# x5 - Swapped.
# x6 - Inner loop variable.

# volatile void bubble_sort (int *array) {
#   int size = 500;
#   // loop to access each array element
#   for (int step = 0; step < size - 1; ++step) {
#     // check if swapping occurs  
#     int swapped = 0;
#     // loop to compare array elements
#     for (int i = 0; i < size - step - 1; ++i) {
#       // compare two array elements
#       // change > to < to sort in descending order
#       if (array[i] > array[i + 1]) {
#         // swapping occurs if elements
#         // are not in the intended order
#         int temp = array[i];
#         array[i] = array[i + 1];
#         array[i + 1] = temp;
#         swapped = 1;
#       }
#     }
#     // no swapping means the array is already sorted
#     // so no need for further comparison
#     if (swapped == 0) {
#       break;
#     }
#   }
# }

# <bubble_sort>
# The first and second instructions must be updated to store ARR_BASE in x1.
80000000:       lui x1,66566
80000004:       addi x1,x1,0
# The third instruction must be updated to store ARR_BASE + (ARR_LEN-1)*4 in x2.
80000008:       addi x2,x1,76
# Outer Loop starts. 
# Reset `x6 = x1 = ARR_BASE`.
8000000c:       add x6,x1,x0
# Reset `swapped` variable.
80000010:       add x5,x0,x0
# Inner Loop starts.
80000014:       lw x4,0(x6)
80000018:       lw x3,4(x6)
# If `x3 <= x4`, skip swapping. Go to <bubble_sort+0x2c>.
8000001c:       bge x3,x4,16 
80000020:       sw x3,0(x6)
80000024:       sw x4,4(x6)
# Update swapped variable if swapping occured.
80000028:       addi x5,x0,1
# Update inner loop variable.
8000002c:       addi x6,x6,4
# If `i < size - step - 1` restart inner loop. Go to <bubble_sort+0x14>.
80000030:       bne x6,x2,-28
# If `swapped=0` then array is already sorted. Go to end of program. 
80000034:       beq x5,x0,12
# The limit of the outer loop is reduced by 4. This accounts for `size - step - 1'.
80000038:       addi x2,x2,-4
# If `x2=x1` then bubble sort is over. Otherwise go to <bubble_sort+0xc>.
8000003c:       bne x2,x1,-48
# Program ends
80000040:       add x0,x0,x0
80000044:       beq x0,x0,-4


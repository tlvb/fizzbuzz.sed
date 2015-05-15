#-; fizzbuzz in posix compliant sed
:A; s/.*/(1,1)/;                     tB
:B; s/,15)/,0)/;h;
:C; s/,1*[05])/&buzz/;
:D; s/,\([0369]\)*\(12\)*)/&fizz/;   tF;
:E; s/(\(.*\),.*/&\1/;
:F; s/.*)//;p;x;
:G; s/[,)]/_&/g;
:H; s/0_/1/g;s/1_/2/g;s/2_/3/g;s/3_/4/g;
:I; s/4_/5/g;s/5_/6/g;s/6_/7/g;s/7_/8/g;
:J; s/8_/9/g;s/9_/_0/g;              tH;
:K; s/_/1/g;                         bB;
#-; echo | sed -f fizzbuzz.sed
#
# idea of operation:
# have two counters, one ever-increasing,
# to keep track of the number (as usual),
# and a second one that resets at 15,
# then fizzes and buzzes can be found by
# comparing the second counter to the values
# 0, 3, 5, 6, 9, 10 and 12
#
#A: initialize two counters in pattern space
#   and reset the t flag
#B: reset the right counter to 0 if it's 15
#   and back up the counters to hold space
#C: add 'buzz' to the right of the counters
#   in pattern space if the right counter is
#   0, 5 or 10
#D: add 'fizz' to the right of the counters
#   in pattern space if the right counter is
#   0, 3, 6, 9, or 12, and branch to F if
#   any of the C or D substitutions were
#   successful, otherwise continue to E
#E: append the left counter value to the right
#   of the counters
#F: remove the counters, print the pattern space
#   contents, which are now contains either
#   fizz, buzz, fizzbuzz, or the value of
#   the left counter, afterwards, restore
#   the counters from hold space
#G: add carry mark to the right of both counters'
#   values
#H: increase each 0, 1, 2, or 3 that has
#   a carry mark to it's right
#I: same, but for digits 4, 5, 6, and 7
#J: same, but for digits 8 and 9, if the digit
#   is 9, a new carry mark is generated to the
#   left, "carry the one"
#   lines H-J are looped as long as any
#   substitution is successful
#K: remaining carry marks at this point correspond
#   to a 1 at the next power of ten
#
# (16,1) -G-> (16_,1_) -H-> (16_,2)  -I-> (17,2)
# (19,4) -G-> (19_,4_) -I-> (19_,5)  -J-> (1_0,5)  -K-> (20,5)
# (99,9) -G-> (99_,9_) -J-> (9_0,_0) -J-> (_00,_0) -K-> (100,10)

************************************************************************
file with basedata            : cr463_.bas
initial value random generator: 471686633
************************************************************************
projects                      :  1
jobs (incl. supersource/sink ):  18
horizon                       :  139
RESOURCES
  - renewable                 :  4   R
  - nonrenewable              :  2   N
  - doubly constrained        :  0   D
************************************************************************
PROJECT INFORMATION:
pronr.  #jobs rel.date duedate tardcost  MPM-Time
    1     16      0       20        4       20
************************************************************************
PRECEDENCE RELATIONS:
jobnr.    #modes  #successors   successors
   1        1          3           2   3   4
   2        3          3           6   9  13
   3        3          3           5   6  11
   4        3          3           7   8  11
   5        3          3          14  15  17
   6        3          2          12  14
   7        3          2           9  10
   8        3          2           9  13
   9        3          1          12
  10        3          3          13  15  17
  11        3          1          12
  12        3          2          16  17
  13        3          1          14
  14        3          1          16
  15        3          1          18
  16        3          1          18
  17        3          1          18
  18        1          0        
************************************************************************
REQUESTS/DURATIONS:
jobnr. mode duration  R 1  R 2  R 3  R 4  N 1  N 2
------------------------------------------------------------------------
  1      1     0       0    0    0    0    0    0
  2      1     5       2    4    5    5    7    4
         2     6       2    3    4    4    7    4
         3    10       1    3    4    4    6    3
  3      1     3       6    6    6    5    9    3
         2     5       5    3    6    3    7    2
         3     7       4    1    4    2    7    1
  4      1     3       7    6    7    4    7    4
         2     6       5    5    3    4    7    4
         3     7       5    5    1    1    6    3
  5      1     4       5   10    6    9    5    7
         2     7       4    9    6    9    5    5
         3    10       2    9    5    9    4    4
  6      1     5       5    3    9    9    4    5
         2     6       4    3    4    8    4    4
         3    10       4    2    1    8    2    1
  7      1     6       5    7    4    5    9    4
         2     6       5    7    3    5    9    6
         3    10       4    6    2    2    8    2
  8      1     1       8    6    7    7    4    5
         2     7       6    3    7    6    4    5
         3    10       5    1    6    5    4    5
  9      1     3       9    8    2    5    7    4
         2    10       6    6    2    2    7    2
         3    10       7    7    2    2    6    2
 10      1     2       9    3    9    9    6    9
         2     3       8    3    6    9    6    9
         3     5       8    2    4    8    5    7
 11      1     3      10   10    9    5   10    1
         2     4       7    8    9    3    9    1
         3     9       7    5    9    2    9    1
 12      1     1       7    8    7    7    8    9
         2     6       7    8    7    6    7    7
         3     7       6    7    6    6    6    2
 13      1     1       7    4    6    9   10    3
         2     8       5    3    4    8    9    3
         3     9       3    2    2    7    9    2
 14      1     3       6    6    5    5    6    4
         2     4       6    5    4    4    4    3
         3     8       4    3    4    4    3    1
 15      1     2       4   10    8   10    7    6
         2     5       4    8    8    8    4    6
         3     8       4    6    7    7    4    6
 16      1     4       8    4    9    7    6    9
         2     8       6    4    7    6    5    4
         3     9       5    4    5    6    4    4
 17      1     7       6    7    7   10    8    8
         2    10       5    5    7    8    7    3
         3    10       3    2    7    8    8    1
 18      1     0       0    0    0    0    0    0
************************************************************************
RESOURCEAVAILABILITIES:
  R 1  R 2  R 3  R 4  N 1  N 2
   25   30   26   26  113   87
************************************************************************
************************************************************************
file with basedata            : cn150_.bas
initial value random generator: 778896426
************************************************************************
projects                      :  1
jobs (incl. supersource/sink ):  18
horizon                       :  129
RESOURCES
  - renewable                 :  2   R
  - nonrenewable              :  1   N
  - doubly constrained        :  0   D
************************************************************************
PROJECT INFORMATION:
pronr.  #jobs rel.date duedate tardcost  MPM-Time
    1     16      0       21       14       21
************************************************************************
PRECEDENCE RELATIONS:
jobnr.    #modes  #successors   successors
   1        1          3           2   3   4
   2        3          2           7   8
   3        3          2           7  11
   4        3          3           5   6   8
   5        3          2           7  16
   6        3          3           9  11  13
   7        3          2          13  17
   8        3          3           9  11  13
   9        3          3          10  12  16
  10        3          2          14  17
  11        3          1          16
  12        3          2          15  17
  13        3          1          14
  14        3          1          15
  15        3          1          18
  16        3          1          18
  17        3          1          18
  18        1          0        
************************************************************************
REQUESTS/DURATIONS:
jobnr. mode duration  R 1  R 2  N 1
------------------------------------------------------------------------
  1      1     0       0    0    0
  2      1     1       8    0    5
         2     8       0    8    2
         3     8       4    0    3
  3      1     3      10    0    8
         2     4      10    0    5
         3     9       0    1    3
  4      1     5       3    0    2
         2     6       2    0    2
         3     8       0    6    2
  5      1     2       0    5    7
         2     5       3    0    5
         3    10       2    0    2
  6      1     4       0   10    3
         2     7       1    0    3
         3     9       0    6    3
  7      1     3       2    0    8
         2     7       0    8    8
         3    10       0    8    7
  8      1     1       0    6    9
         2     1       9    0    8
         3     8       6    0    5
  9      1     1       0    8    7
         2     5       7    0    4
         3     7       5    0    3
 10      1     1       8    0   10
         2     3       7    0    9
         3    10       0    7    9
 11      1     4       4    0    8
         2     4       0    5    8
         3     5       0    3    7
 12      1     2       6    0   10
         2     5       4    0    5
         3     6       0    6    5
 13      1     4       0   10    4
         2     4       5    0    4
         3     6       2    0    4
 14      1     4      10    0    8
         2     4       0    7    8
         3     9       0    6    7
 15      1     3       0    9    6
         2     4       0    9    5
         3     6       0    9    2
 16      1     5       9    0    4
         2     7       2    0    2
         3     8       0    9    1
 17      1     2       0    2    6
         2     6       6    0    4
         3    10       5    0    1
 18      1     0       0    0    0
************************************************************************
RESOURCEAVAILABILITIES:
  R 1  R 2  N 1
   13   21   95
************************************************************************
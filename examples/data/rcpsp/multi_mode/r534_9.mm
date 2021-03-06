************************************************************************
file with basedata            : cr534_.bas
initial value random generator: 1000615439
************************************************************************
projects                      :  1
jobs (incl. supersource/sink ):  18
horizon                       :  116
RESOURCES
  - renewable                 :  5   R
  - nonrenewable              :  2   N
  - doubly constrained        :  0   D
************************************************************************
PROJECT INFORMATION:
pronr.  #jobs rel.date duedate tardcost  MPM-Time
    1     16      0       17        2       17
************************************************************************
PRECEDENCE RELATIONS:
jobnr.    #modes  #successors   successors
   1        1          3           2   3   4
   2        3          2           5   8
   3        3          3          10  11  13
   4        3          3           6  10  13
   5        3          2           6  13
   6        3          3           7   9  14
   7        3          2          15  17
   8        3          3          11  12  16
   9        3          2          11  12
  10        3          1          14
  11        3          1          17
  12        3          1          15
  13        3          3          15  16  17
  14        3          1          16
  15        3          1          18
  16        3          1          18
  17        3          1          18
  18        1          0        
************************************************************************
REQUESTS/DURATIONS:
jobnr. mode duration  R 1  R 2  R 3  R 4  R 5  N 1  N 2
------------------------------------------------------------------------
  1      1     0       0    0    0    0    0    0    0
  2      1     4       0    9    5    0    3    7    4
         2     5       0    8    5    2    2    6    3
         3     7       0    7    0    0    0    6    2
  3      1     2       0    7    3    0    0    4    7
         2     6       6    5    0    3    4    3    4
         3     6       0    6    0    3    0    3    5
  4      1     5       4   10   10    5    8    3    8
         2     6       0    9    8    2    0    3    7
         3    10       0    0    0    1    0    3    6
  5      1     1       2    0    0    0    0    7    5
         2     7       0    0    7    6    0    7    5
         3     9       0    3    0    6    0    6    2
  6      1     2       0    0    0    0   10    5    7
         2     7       0    0    0    4    0    1    7
         3     7       0    0    5    4    6    2    6
  7      1     1       0    5    3    0    7    7    9
         2     5       2    4    0    9    0    6    5
         3     6       0    0    0    9    6    1    4
  8      1     1       0    0    6   10    0    8    8
         2     3       0    7    5    0    2    5    5
         3     5       0    0    4    0    0    3    5
  9      1     3       0    0    0    6    9    6    6
         2     4       0    6    0    0    0    6    6
         3     5       0    4    9    0    7    3    6
 10      1     4       8    1    6    0    0    9    5
         2    10       6    0    0    0    0    5    5
         3    10       0    0    0    0    3    4    4
 11      1     6       5    5    7    2    0    7    5
         2     7       4    0    0    2    0    4    5
         3     7       0    0    5    0    4    4    4
 12      1     2       0    3    8    0    9    7    8
         2     3       0    2    7    0    0    6    6
         3     9       2    0    5    0    2    5    3
 13      1     4       5    0    0    6    0    4    8
         2     7       2    9    0    3    0    3    7
         3     8       0    7    5    1    7    1    7
 14      1     3       4    0    0    7    8    8    4
         2     5       0    0    0    5    8    7    3
         3     8       0    4    0    1    8    7    2
 15      1     2       6    8    6    7    2   10    5
         2     2       6    0    0    8    0   10    5
         3     9       0    0    0    7    0    9    3
 16      1     1       4    4    4    3    0    8    2
         2     5       0    0    2    2    8    8    2
         3     5       4    3    0    1    8    8    2
 17      1     1       8    0    0    0    5    8    2
         2     3       8   10    0    9    4    6    2
         3     5       5    0    0    5    2    4    1
 18      1     0       0    0    0    0    0    0    0
************************************************************************
RESOURCEAVAILABILITIES:
  R 1  R 2  R 3  R 4  R 5  N 1  N 2
   10   17   14   15   17   78   69
************************************************************************

************************************************************************
file with basedata            : cm161_.bas
initial value random generator: 1206597311
************************************************************************
projects                      :  1
jobs (incl. supersource/sink ):  18
horizon                       :  96
RESOURCES
  - renewable                 :  2   R
  - nonrenewable              :  2   N
  - doubly constrained        :  0   D
************************************************************************
PROJECT INFORMATION:
pronr.  #jobs rel.date duedate tardcost  MPM-Time
    1     16      0       38       15       38
************************************************************************
PRECEDENCE RELATIONS:
jobnr.    #modes  #successors   successors
   1        1          3           2   3   4
   2        1          3           5  10  16
   3        1          3           6   7  11
   4        1          3           6   9  12
   5        1          3          11  12  17
   6        1          1           8
   7        1          3           8  10  12
   8        1          2          13  14
   9        1          3          10  14  15
  10        1          1          17
  11        1          1          13
  12        1          1          13
  13        1          1          15
  14        1          2          16  17
  15        1          1          18
  16        1          1          18
  17        1          1          18
  18        1          0        
************************************************************************
REQUESTS/DURATIONS:
jobnr. mode duration  R 1  R 2  N 1  N 2
------------------------------------------------------------------------
  1      1     0       0    0    0    0
  2      1    10       9    4    9    9
  3      1     9       2    6    8    2
  4      1     9       4    3    5    7
  5      1     6       3    4    5    7
  6      1    10       7    1    8    4
  7      1     8       1    4    3    4
  8      1     1       5    2    8    9
  9      1     1       2    7    7    7
 10      1     6       5    7    5    6
 11      1     2       5    5    7    3
 12      1     6       2    5    3    6
 13      1     8       3    7    5    1
 14      1     2       2    6    8    8
 15      1     7       6    7    2   10
 16      1     7       7    5    7    8
 17      1     4       5    6    1    2
 18      1     0       0    0    0    0
************************************************************************
RESOURCEAVAILABILITIES:
  R 1  R 2  N 1  N 2
   12   10   91   93
************************************************************************

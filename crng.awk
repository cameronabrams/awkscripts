# given a user-specified range of columns
# (e.g., 1-100) output those columns in the input line that
#
# invoked as 
# awk -f crng.awk -v c0=(#) -v c1=(#) -v c2=(#)
#
# the range is then c0,c1-c2
#
# (c) 1999 cam abrams
# university of california, berkeley
# dept. of chemical engineering
#
{
  printf("%s ", $c0);
  for (i=c1;i<=c2;i++) printf("%s ",$i);
  printf("\n");
}

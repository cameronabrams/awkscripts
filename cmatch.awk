# given a user-specified character 'c',
# output all fields in the input line that
# contain that character
#
# (c) 1999 cam abrams
# university of california, berkeley
# dept. of chemical engineering
#
{
  for (i=1;i<=NF;i++) if (match($i,c)) printf("%s ",$i);
  printf("\n");
}

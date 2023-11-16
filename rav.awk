# compute and output running averages of a column-oriented data file
# data in the first column is assumed to be x-data, and is NOT averaged.
# Lines in the data file that begin with '#'
# are skipped.
#
# (c) 1999 cam abrams
# university of california, berkeley
# dept. of chemical engineering
#
BEGIN{
   i=0;
   for (j=1;j<=10;j++) s[j]=0;
}
{
   if (!match("#",$1)) {
     for (j=2;j<=NF;j++) s[j]+=$j;
     i++;
     for (j=1;j<=NF;j++) {
        printf("%.5f ",(j==1?$j:s[j]/i));
     }
     printf("\n");
   }
}

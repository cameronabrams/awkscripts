# normalizes a column-oriented data file by dividing each element
# in a row by the sum of all elements in the row
# Data in the first column is assumed to be x-data, and is NOT included
# in the normalization, but it IS output in column 1.
# Lines in the data file that begin with '#'
# are skipped.
#
# (c) 1999 cam abrams
# university of california, berkeley
# dept. of chemical engineering
#
{
   if (!match("#",$1)) {
     s=0;
     for (j=2;j<=NF;j++) s+=$j;
     for (j=1;j<=NF;j++) {
        printf("%.5f ",(j==1?$j:(s?$j/s:0)));
     }
     printf("\n");
   }
}

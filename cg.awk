# coarse grain a column-oriented data file
# must be invoked with cg=#, where # is the
# desired coarse-graining factor.
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
   if (!match($1,"#")) {
     for (j=1;j<=NF;j++) if (!match($j,"+/-")) s[j]+=$j;
     i++;
     if (i==cg) {
        for (j=1;j<=NF;j++) if (!match($j,"+/-")) {
            printf("%.5f ",s[j]/cg);
            s[j]=0;
        }
        printf("\n");
        i=0;
     }
   }
}

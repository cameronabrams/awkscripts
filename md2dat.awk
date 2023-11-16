#
#
# md2dat.awk
#
# extracts data from an md2 log file.
# the data extracted is 
# i nsi nf nc
# where i is the impact #, nsi is # of si atoms, 
# nf is # of f atoms and nc is # of c atoms
#
# works with an md series 2 log file, 7 Jun 1999
#
# invoke as:
# % awk -f md2dat.awk log > dat
#
#
# (c) 1999 cameron abrams
#
#
#
BEGIN{
   system("date +'#%I:%M%p,%e%b%Y'");
}
/^# Tr /{
   for (i=1;i<=NF;i++)
   {
	if (match($i,"Si")) nsi=$(i+1);
	else if (match($i,"F")) nf=$(i+1);
	else if (match($i,"C")) nc=$(i+1);
	else if (match($i,"H")) nh=$(i+1);
   }
   i=$3;
   printf("%i %i %i %i %i\n",i,nsi,nf,nc,nh);
}

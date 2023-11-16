# slav.awk
#
# Compute and output degree-`N' sliding averages of 
# a column-oriented data file of `M' x-y pairs.
#
# Input file is of the format
#
# x_1 y_1
# x_2 y_2
# ...
# x_M y_M
#
# Output (stdout) is of the format
#
# x_1 s_1
# x_2 s_2
# ...
# x_M y_M
#
# The i'th sliding average of degree N is given by
#
#  s_i = 1/N_i*sum_(j=i-N_i/2)^(i+N_i/2) (y_j)
#
# where N_i = min(2*(i-1),N,2*(M-i))
# 
# Data in the first column is assumed to be x-data, and is NOT averaged.
#
# Lines in the data file that begin with '#' are skipped.
#
# (c) 2000 cam abrams
# university of california, berkeley
# dept. of chemical engineering
#
# max-planck-institut for polymer research
# mainz, germany
#
BEGIN{
   # maximum number of columns is 10
   NC=10;
   # maximum degree is 100
   N=100;
   for (i=1;i<=N;i++) for (j=1;j<=NC;j++) buf[i,j]=0;
   ii=0;
   bufi=0;
   oi=i;
}
{
   if (!match("#",$1)) 
   {
     ii++;  # increment input line number
     Ni=ii
     if (Ni>N) Ni=N
     oi=ii-Ni/2  # output line number
     bufi++;  # increment buffer line number
     if (bufi>Ni) bufi=Ni;
   }
}

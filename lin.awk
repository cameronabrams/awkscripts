# lin.awk
#
# fit a best fit line to y vs x data
#
# (c) 1999 cameron abrams
#
{
  sx+=$1;
  sxx+=$1*$1;
  sy+=$2;
  syy+=$2*$2;
  sxy+=$1*$2;
}
END{
  m=(sxy-sx*sy/NR)/(sxx-sx*sx/NR);
  b=sy/NR-m*sx/NR;
  printf("%.5f %.5f : %.5f %.5f\n",b,a,z,(z-b)/m);
}

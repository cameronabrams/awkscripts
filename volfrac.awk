BEGIN{
  r_0=0.5;
  R=1.122462048;
  v=0.0;
  vf=0.0;
  nfr=1;
  N=4000;
}
{
  r1=R-r_0;
  r2=R+r_0;
  r=$1;  # radius
  c=$3;  # count
  if ( r < r1 ) v+=c;
  else if ( r < r2 ) {
   vf+=f(r)*c;
#   print r,f(r),c,f(r)*c
  }
}
END{
  V=(r_0*r_0*r_0)/(R*R*R)*(v+vf);
#  fprintf(stderr,"# nfr %i N %i : Vfrac %.4f\n",nfr,N,V/nfr/N);
  printf("%.4f\n",V/nfr/N);
}

function f ( r ) {
  return 0.5 - 0.75*y(r)/r_0 + 0.25*(y(r)/r_0)**3;
}

function y ( r ) {
  return r?(0.5*r - 0.5/r*(R*R-r_0*r_0)):0.0;
}

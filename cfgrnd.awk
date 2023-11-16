#
# cfgrnd.awk 
#
# developed for use with Gnu Awk (gawk) 2.15, patchlevel 6
# by cameron abrams 17 nov 1999
#
BEGIN{
  d=5;atom=0;
}

/#/{print $0}
/%/{print $0}
/^[0-9]/{
  id=$1;
  sym=$2;
  x=$3;
  y=$4;
  z=$5;
  vx=$6;
  vy=$7;
  vz=$8;
  fix=$9;
  fmt=sprintf("%s\t%s\t%%.%i%s\t%%.%i%s\t%%.%i%s\t%%.%i%s\t%%.%i%s\t%%.%i%s\t%s\n",
    "%i","%s",d,"lf",d,"lf",d,"lf",d,"lf",d,"lf",d,"lf","%i");
  printf(fmt,
    atom,sym,x,y,z,vx,vy,vz,fix);
  atom++;
}
END{}

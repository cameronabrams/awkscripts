#
# cfgrot.awk -- an awk script that rotates an md series 2 configuration
# data file through user-specified rotations
#
# developed for use with Gnu Awk (gawk) 2.15, patchlevel 6
# by cameron abrams 17 nov 1999
#
BEGIN{
xtr=0.0;ytr=0.0;ztr=0.0;
}

/#/{print $0}
/%/{print $0}
/^[0-9]/{
  atom++;
  id=$1;
  sym=$2;
  x=$3;
  y=$4;
  z=$5;
  vx=$6;
  vy=$7;
  vz=$8;
  fix=$9;
  printf("%i\t%s\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%i\n",
    atom,sym,x+xtr,y+ytr,z+ztr,vx,vy,vz,fix);
}
END{}

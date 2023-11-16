#
# cfgshift.awk -- an awk script that shifts an md series 2 configuration
# data file through user-specified translations, enforcing periodic
# boundary conditions
#
# developed for use with Gnu Awk (gawk) 2.15, patchlevel 6
# by cameron abrams 9 december 1999
#
BEGIN{
xs=0.0;ys=0.0;zs=0.0;
}

/#/{print $0}
/#BoxSize.xyz/ {lx=$2; ly=$3; lz=$4; hlx=lx/2; hly=ly/2; hlz=lz/2;}
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
  x+=xs;
  y+=ys;
  z+=zs;
  if (x>hlx) x-=lx;
  if (x<-hlx) x+=lx;
  if (y>hly) y-=ly;
  if (y<-hly) y+=ly;
  if (z>hlz) z-=lz;
  if (z<-hlz) z+=lz;
  printf("%i\t%s\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%i\n",
    atom,sym,x,y,z,vx,vy,vz,fix);
}
END{}

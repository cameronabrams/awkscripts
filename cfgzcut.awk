#
# cfgzcut.awk -- an awk script that cuts an md series 2 or 3 configuration
# at a specified z-position, outputting all atoms that lie above
# that position.
#
# Example:  To slice off the top 10 angstroms of atoms in a cfg file
# called "0001.cfg" and output to "0002.cfg", do the following:
# (1) determine the highest atom in 0001.cfg; note its z-position.
# (2) use this script to cut 0001.cfg, with the zcut parameter set
#     to the z-position of the highest atom in 0001.cfg minus 10, [####]:
#     % awk -f cfgzcut.awk zcut=[####] 0001.cfg > 0002.cfg
#
# developed for use with Gnu Awk (gawk) 2.15, patchlevel 6
# by cameron abrams 31 January 2000
#
BEGIN{
zcut=0.0;
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
  if (z>=zcut) printf("%i\t%s\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%i\n",
    atom,sym,x,y,z,vx,vy,vz,fix);
}
END{}

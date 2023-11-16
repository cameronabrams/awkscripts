#
# trans.awk
#
# trans.awk operates on a standard md series 2 config file.
# it first reads in the box size, then translates the positions
# of all atoms by an integral number of boxsizes in each
# dimension requested.  if the parameter n0 is set, each
# atom is numbered sequentially in the output beginning
# with n0+1.  output is to stdout.
#
# developed for Gnu Awk (gawk) 2.15, patchlevel 6
# by Cameron Abrams
# 20 Oct 1999
#
BEGIN{
 nx=0;
 ny=0;
 nz=0;
 n0=0;
}
/\#BoxSize.xyz/{ bsx=$2; bsy=$3; bsz=$4; }
/% Number of Atoms in this cfg =/ { na=$9; }
/^\#/{print $0}
/^\%/{print $0}
/^[0-9]/ { printf("%i\t%s\t%0.16lf\t%0.16lf\t%0.16lf\t%0.16lf\t%0.16lf\t%0.16lf%i\n",
	($1+n0),$2,($3+nx*bsx),($4+ny*bsy),($5+nz*bsz),$6,$7,$8,$9); }
END{}

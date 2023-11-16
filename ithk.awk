# ithk.awk
# operates on cfginfo data files
# specifically, columns 1, 4, 9, 14 of those files
# which are z, x_Si(z), x_F(z), and x_C(z) respectively.
# computes z_1, or the lowest z for which x_C(z) > 0.10,
# and z_2, the highest z for which x_Si(z) > 0.10.
#
# the interfacial zone thickness is then defined as z_2-z_1
#
BEGIN{z2=-10.0;
      z1=100.0;
}
{
   if (!match($1,"#")) {
	z=$1;
	xsi=$4;
	xf=$9;
	xc=$14;
	
	if (xc > 0.10 && z < z1) z1=z;
	if (xsi > 0.10 && z > z2) z2=z;
   }
}
END{printf("%.5lf\n",z2-z1);}

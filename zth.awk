# zth.awk
#
# (c) 1999 cameron abrams
#
# for use with gnu-awk
#
# description:  zth awk has one function:  calculate and
# return the number `zth', which has the following
# definition:
#
# zth is that z-coordinate value such it is the minimum z at which the 
# density profile for fluorine is M of its maximum value, where M
# is a user-specified parameter.
#
# zth.awk is used on an *info file; see the following example:
#
#  > awk -f zth.awk M=0.10 1001.info
#  1.2345
#  >
#
# Here, I've asked zth.awk to find zth(M=10%) in the file 1001.info.
#
# The two columns of any *info file examined are 1 (z, A) and
# 7 (#F(z)).
# 
# 
#
BEGIN{
	M=0.10;
	N=200;
  	for (i=1;i<=N;i++) {z[i]=f[i]=0.0;}
	i=0;
	MaxF=0.0;
}
{
	if (!match($1,"#")) {
		i++;
		z[i]=$1;
		f[i]=$7;
		if (MaxF<f[i]) MaxF=f[i];
#		print z[i], f[i], MaxF;
	}
}
END{
	MaxF*=M;
#	print MaxF;	
	for (i=1;i<=N&&f[i]<MaxF;i++);
	if (i<=N&&i>1) 
	{
#		interpolate
		m=(f[i]-f[i-1])/(z[i]-z[i-1]);
		zth=(M-f[i-1])/m+z[i-1];
		printf("%.5lf\n",zth);
	}
	else printf("---\n");
}

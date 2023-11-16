#
# cfgrho.awk -- an awk script that computes density in a given
# slice of a cfg file
#
# developed for use with Gnu Awk (gawk) 2.15, patchlevel 6
# by cameron abrams 13 nov 1999
#
BEGIN{
nx=5;
ny=5;
zlo=10.0
zhi=20.0;
n=0;
nrm=1.0;
for (i=1;i<100;i++) for (j=1;j<=100;j++) grid[i,j]=0;
for (i=1;i<100;i++) for (j=1;j<=100;j++) ht[i,j]=0.0;
}

/#BoxSize.xyz/{ 
bsx=$2; xlo=-bsx/2.0; xhi=-xlo; 
bsy=$3; ylo=-bsy/2.0; yhi=-ylo;
bsz=$4;
for (i=1;i<=nx;i++) for (j=1;j<=ny;j++) grid[i,j]=0;
for (i=1;i<100;i++) for (j=1;j<=100;j++) ht[i,j]=zlo;
dx=bsx/nx; dy=bsy/ny;
#printf("dx %.3lf  dy %.3lf\n", dx,dy);
}
/^[0-9]/{
  x=$3;
  y=$4;
  z=$5;
  if (z>zlo&&z<zhi)
  {
    bx=int((x-xlo)/bsx*nx+1); by=int((y-ylo)/bsy*ny+1);
#    printf("%i %.3lf %.3lf\n", $1, z, ht[bx,by]);
    if (z>ht[bx,by]) ht[bx,by]=z;
    grid[bx,by]++;
  }
}
END{
    sum=ssum=0.0;
    for (i=1;i<=nx;i++)
    { 
	for (j=1;j<=ny;j++)
	{
	   rho=grid[i,j]/(dx*dy*(ht[i,j]-zlo));
#	   printf("(%.3lf) ", rho);
	   sum+=rho;
   	   ssum+=rho*rho;
	}
#	printf("\n");
    }
    printf("# mean: %.3lf +/- %.3lf\n",
	sum/(nx*ny)/nrm, sqrt((ssum-sum*sum/(nx*ny))/(nx*ny-1))/nrm);
}


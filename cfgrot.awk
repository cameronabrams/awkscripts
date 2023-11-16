#
# cfgrot.awk -- an awk script that rotates an md series 2 configuration
# data file through user-specified rotations
#
# developed for use with Gnu Awk (gawk) 2.15, patchlevel 6
# by cameron abrams 17 nov 1999
#
BEGIN{
maxrots=40;		/* maximum number of rotations allowed */
for (i=1;i<=maxrots;i++) rotax[i]=0; # 1==x, 2==y, 3==z, 0==no rot.
for (i=1;i<=maxrots;i++)  rots[i]=0.0;
j=0;
# extract rotations in order from command line options
for (i=1;i<=ARGC;i++)
{
  if (match(ARGV[i],"xr=")) 
  {
    j++;
    rotax[j]=1;
    split(ARGV[i],a,"=");
    rots[j]=a[2];
  }
  else if (match(ARGV[i],"yr=")) 
  {
    j++;
    rotax[j]=2;
    split(ARGV[i],a,"=");
    rots[j]=a[2];
  }
  else if (match(ARGV[i],"zr=")) 
  {
    j++;
    rotax[j]=3;
    split(ARGV[i],a,"=");
    rots[j]=a[2];
  }
}

# initialize rotation identity matrix
for (i=1;i<4;i++) {
 for (j=1;j<4;j++) rot[i,j]=0.0;
 rot[i,i]=1.0;
}
PI=3.14159265358979323846;
atom=0;
}

function compute_matrix(){

 # compute the rotation matrix:
 # initialize to identity matrix
 for (i=1;i<4;i++) {
   for (j=1;j<4;j++) rot[i,j]=0.0;
   rot[i,i]=1.0;
 }
 # for each requested rotation around a principle axis
 for (l=1;l<maxrots&&rotax[l];l++)
 {
   # initialize two temporary matrices to identities
   for (i=1;i<4;i++) {
     for (j=1;j<4;j++) t[i,j]=0.0;
     t[i,i]=1.0;
   }
   for (i=1;i<4;i++) {
     for (j=1;j<4;j++) q[i,j]=0.0;
     q[i,i]=1.0;
   }
   
   # compute sine and cosine of requested angle
   sinT=sin(PI/180.0*rots[l]);
   cosT=cos(PI/180.0*rots[l]);
   
#   printf("# rotation %i: %.1f deg around %s axis; s=%.5lf,c=%.5lf\n",
#	l, rots[l], rotax[l]==1?"x":(rotax[l]==2?"y":"z"),sinT,cosT);

   # assign elements of temporary matrix based on which axis
   # is the center of rotation
   if (rotax[l]==1) # yy,yz,zy,zz
   {
      t[2,2]=cosT; t[2,3]=-sinT;
      t[3,2]=sinT; t[3,3]=cosT;
   }
   else if (rotax[l]==2)
   {
     t[1,1]=cosT; t[1,3]=-sinT;
     t[3,1]=sinT; t[3,3]=cosT;
   }
   else if (rotax[l]==3)
   {
     t[1,1]=cosT; t[1,2]=-sinT;
     t[2,1]=sinT; t[2,2]=cosT;
   }

   # initialize the other temporary matrix to the
   # current values of the rotation matrix
   for (i=1;i<4;i++){
    for (j=1;j<4;j++) q[i,j]=rot[i,j];
   }

   # multiply the second temporary matrix by the first;
   # store the result in the rotation matrix
   for (i=1;i<4;i++) {
    for (j=1;j<4;j++) {
     rot[i,j]=0.0;
     for (k=1;k<4;k++) {
      rot[i,j]+=q[i,k]*t[k,j];
     }
    }
   }
 }

}

/#/{print $0}
/%/{print $0}
/#BoxSize.xyz/{compute_matrix();}
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
  nx=x*rot[1,1]+y*rot[1,2]+z*rot[1,3];
  ny=x*rot[2,1]+y*rot[2,2]+z*rot[2,3];
  nz=x*rot[3,1]+y*rot[3,2]+z*rot[3,3];
  printf("%i\t%s\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%.14lf\t%i\n",
    atom,sym,nx,ny,nz,vx,vy,vz,fix);
}
END{}

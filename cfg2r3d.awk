#
# cfg2r3d.awk -- an awk script that converts an md series 2 configuration
# data file into r3d format for rendering by Raster3D
#
# developed for use with Gnu Awk (gawk) 2.15, patchlevel 6
# by cameron abrams 20 oct 1999
#
BEGIN{
deplim=10000;
maxrots=40;
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

PI=3.14159265358979323846;
title="tmp1";
xtls=32; ytls=32;		# number of tiles in x and y (image size)
xppt=18; yppt=18;		# number of pixels in x and y per tile
schm=3;				# antialiasing scheme
bg[1]=0.0; bg[2]=0.0; bg[3]=0.0;# background rgb triple (color)
shad="T";			# default is to draw shadows
phng=25;			# phong power
slc=0.15;			# secondary light contribution
alc=0.05;			# ambient light contribution
src=0.25;			# specular reflection contribution
eyepos=4.0;			# eye position
ml[1]=1.0;ml[2]=1.0;ml[3]=1.0;	# main light position x, y, z
xtr=0.0;ytr=0.0;ztr=0.0;        # x, y, z object translation
zoom=1.0;			# zoom factor

clr=1;				# colorscheme: 1=color by elements,
				# 2=color by depth, 3=color by kinetic energy
fc=1;				# color fixed atoms darker?

atom=0;
}

function print_header(nrm){
 printf("%s\n",title);
 printf("%i %i\n",xtls,ytls);
 printf("%i %i\n",xppt,yppt);
 printf("%i\n",schm);
 if (bgp)  split(bgp,bg,",");
 printf("%.3lf %.3lf %.3lf\n",bg[1],bg[2],bg[3]);
 printf("%s\n",shad);
 printf("%i\n",phng);
 printf("%.2lf\n",slc);
 printf("%.2lf\n",alc);
 printf("%.2lf\n",src);
 printf("%.2lf\n",eyepos);
 if (mlp) split(mlp,ml,",");
 printf("%.2lf %.2lf %.2lf\n", ml[1],ml[2],ml[3]);
 # compute the rotation matrix:
 # initialize to identity matrix
 for (i=1;i<5;i++) {
   for (j=1;j<5;j++) row[i,j]=0.0;
   row[i,i]=1.0;
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
    for (j=1;j<4;j++) q[i,j]=row[i,j];
   }

   # multiply the second temporary matrix by the first;
   # store the result in the rotation matrix
   for (i=1;i<4;i++) {
    for (j=1;j<4;j++) {
     row[i,j]=0.0;
     for (k=1;k<4;k++) {
      row[i,j]+=q[i,k]*t[k,j];
     }
    }
   }
 }

 # normalize the translational elements of the matrix
 row[4,1]=xtr/nrm;row[4,2]=ytr/nrm;row[4,3]=ztr/nrm;row[4,4]=1.0/zoom;

 # output matrix
 for (i=1;i<5;i++) {
  for (j=1;j<5;j++) {
   printf("%.4lf ",row[i,j]);
  }
  printf("\n");
 }

 printf("3\n*\n*\n*\n");  # end of header info
}

/#BoxSize.xyz/{ bsx=$2; bsy=$3; bsz=$4; 
nrm=sqrt(bsx*bsx+bsy*bsy+bsz*bsz);print_header(nrm);}
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
  ke=0.5*get_m(sym)*(vx*vx+vy*vy+vz*vz);
  fix=$9;
  rad=get_rad(sym);
  r=get_r(sym)*(fix&&fc?0.2:1.0);
  g=get_g(sym)*(fix&&fc?0.2:1.0);
  b=get_b(sym)*(fix&&fc?0.2:1.0);
  if (atom>deplim)
  {
    tmpnum=b; b=r; r=g; g=tmpnum;
  }
  printf("# atom %s_%i\n", sym, id);
  printf("2\n");
  printf("%.3lf %.3lf %.3lf %.3lf %.3lf %.3lf %.3lf\n",
	x/nrm,y/nrm,z/nrm,rad/nrm,r,g,b);
}
END{}

function get_rad(sym){
  if (match(sym,"Si")) rad=1.0;
  else if (match(sym,"C")) rad=0.6;
  else if (match(sym,"F")) rad=0.7;
  else if (match(sym,"H")) rad=0.35;
  else rad=0.5;
  return rad;
}
function get_r(sym){
  if (match(sym,"Si")) r=0.0;
  else if (match(sym,"C")) r=0.0;
  else if (match(sym,"F")) r=1.0;
  else r=1.0;
  return r;
}
function get_g(sym){
  if (match(sym,"Si")) g=0.15;
  else if (match(sym,"C")) g=1.0;
  else if (match(sym,"F")) g=0.01;
  else g=1.0;
  return g;
}
function get_b(sym){
  if (match(sym,"Si")) b=0.8;
  else if (match(sym,"C")) b=0.1;
  else if (match(sym,"F")) b=0.01;
  else b=1.0;
  return b;
}
function get_m(sym){
  if (match(sym,"Si")) m=28.085;
  else if (match(sym,"C")) m=12.011;
  else if (match(sym,"F")) m=18.998;
  else if (match(sym,"H")) m=1.008;
  else m=0.0;
  return 1.036477518e-4*m;
}

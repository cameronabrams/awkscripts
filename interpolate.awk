# interpolate.awk
#
# input is formatted as:
# column 1: x data
# columns 2-NF: y data
#
# given the value of z, interpolates 
# values for y_i(z)
#
# (c) 14 october 1999 cameron abrams
#
BEGIN{  fmt="%.5lf ";
	lastx=0.0;
       for (i=1;i<=100;i++) y[i]=lasty[i]=m[i]=b[i]=yint[i]=0.0; }
{
   x=$1;
   for (i=2;i<=NF;i++) y[i-1]=$i;

   if (z>lastx&&z<x)
   {
       dx=x-lastx;
       for (i=1;i<NF;i++) 
       {
  	   m[i]=(y[i]-lasty[i])/dx;
	   b[i]=y[i]-m[i]*x;
	   yint[i]=m[i]*z+b[i];
       }
       nextfile;
   }

   lastx=x;
   for (i=2;i<=NF;i++) lasty[i-1]=y[i-1];
}
END{
   for (i=1;i<NF;i++) printf(fmt,yint[i]);
   printf("\n");
}

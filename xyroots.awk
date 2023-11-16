# xyroots.awk
#
# estimates where a set of tabulated xy data crosses y=0
# 
# input is formatted as:
# column 1: x data
# columns 2: y data
#
#
# (c) 6 february 2001 cameron abrams
# mainz, germany
#
BEGIN{  fmt="%.5lf %.5lf %s\n";
	lastx=0.0;
	lasty=0.0;
	m=0.0;
	b=0.0;
	x=0.0;
	y=0.0;
	i=0;
}
{
   x=$1; y=$2;
   if (i>0) {
     if ((lasty<0&&y>0) || (lasty>0&&y<0)) {
       dx=x-lastx;
       m=(y-lasty)/dx;
       b=y-m*x;
       printf(fmt,(y-b)/m,0.0,(lasty<0&&y>0)?"min":"max");
     }     
   }

   lastx=x;
   lasty=y;
   i++;
}


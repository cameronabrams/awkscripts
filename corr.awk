BEGIN{
   sx=0.0;
   sy=0.0;
   sxy=0.0;
   fmt="%.5le";
}
{
  x=$1; y=$2;
   sx+=x;
   sy+=y;
   sxy+=x*y;
}
END{
   bigfmt=sprintf("%s - %s * %s = %s\n",fmt,fmt,fmt,fmt);
   printf(bigfmt,sxy/NR,sx/NR,sy/NR,sxy/NR-sx*sy/(NR*NR));
}


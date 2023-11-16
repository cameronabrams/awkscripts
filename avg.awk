BEGIN{
   MN=1000.00;
   MX=-1000.00;
   s=0.0;
   s2=0.0;
   fmt="%.5lf";
}
{
   x=$1;
   s+=x;
   s2+=x*x;
   MN=x<MN?x:MN;
   MX=x>MX?x:MX;
}
END{
   bigfmt=sprintf("%s %s %s %s\n",fmt,fmt,fmt,fmt);
   printf(bigfmt,
           s/NR, sqrt((s2-s*s/NR)/NR), MN, MX);
}


BEGIN{
   fmt="%.5le";
}
{
   bigfmt=sprintf("%s %s %s %s\n",fmt,fmt,fmt,fmt);
   MN=1000.00;
   MX=-1000.00;
   s=0.0;
   s2=0.0;
   for (i=1;i<=NF;i++) {
     x=$i;
     s+=x;
     s2+=x*x;
     MN=x<MN?x:MN;
     MX=x>MX?x:MX;
   }
   printf(bigfmt,
           s/NF, sqrt((s2-s*s/NF)/NF), MN, MX);
}
END{
}


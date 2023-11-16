BEGIN{
# default values
   y=3;
   Ei=100;
   dir=".";
   ymin1=0
   ymax1=1.0
   ymin2=0
   ymax2=1.0
   ytics1="(0, 0.2, 0.4, 0.6, 0.8)"
   ytics2="(0, 0.2, 0.4, 0.6, 0.8, 1.0)"
   l1x=1500;
   l2x=1500;
   l1y=0.5;
   l2y=0.5;
   lb1fs=1.0;
   lb1txt="";
   f="datafile";
   sx=0.5;
   sy=0.3;
   fntsz=12;
   fnt="Helvetica";
}
{
   gsub("@y@",y);
   gsub("@Ei@",Ei);
   gsub("@dir@",dir);
   gsub("@ymin1@",ymin1);
   gsub("@ymin2@",ymin2);
   gsub("@ymax1@",ymax1);
   gsub("@ymax2@",ymax2);
   gsub("@ytics1@",ytics1);
   gsub("@ytics2@",ytics2);
   gsub("@l1x@",l1x);
   gsub("@l2x@",l2x);
   gsub("@l1y@",l1y);
   gsub("@l2y@",l2y);
   gsub("@f@",f);
   gsub("@fnt@",fnt);
   gsub("@sx@",sx);
   gsub("@sy@",sy);
   gsub("@fntsz@",fntsz);
   gsub("@lb1fs@",lb1fs);
   gsub("@lb1txt@",lb1txt);
   print $0;
}

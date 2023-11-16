BEGIN{
  newhost="";
  host="";
  badhost="";
  s=0.0;
  nss=0.0;
  nxl=0.0;
  nj=0;
  newncpu=0;
  ncpu=0;
  newpsd=0;
  spd=0;
  rcs="";
  mys="";
  myj=0;
  dlf="<tr ALIGN=CENTER %s><td>%s</td><td>%s</td><td>%s</td><td>%.2f</td><td>%i%s</td>\n"
} 
{
  if (match($1,"#")&&!match($2,"ssh")) 
  {
    if (badhost!="") printf(dlf,"BGCOLOR=#777777",badhost,0,0,0.0,0,0);
    host=newhost;
    ncpu=newncpu;
    spd=newspd;
    badhost="";
    if (host!="") 
    {
      rcs=(s<5?"BGCOLOR=#00ff00":(nss>10?"BGCOLOR=#ff0000":(nxl>1?"BGCOLOR=#ff00dd":"")));
      mys="";
      if (myj>0) 
	mys=sprintf("<sup><font size=1 color=11ddee>(%ic)</font></sup>",myj);
#      printf("<![%s][%i]>\n",mys,myj);
      printf(dlf,rcs,host,ncpu,spd,s/100,nj,mys);
      s=0.0;
      nss=0.0;
      nxl=0.0;
      nj=0;
      myj=0;
    }
    newhost=substr($1,2);
    newncpu=$2;
    newspd=$4;
  } 
  else if (!match($2,"ssh"))
  {
    s+=$1;
    if (match($4,"etscape")) {nss+=$1;}
    if (match($4,"xlock")||match($4,"dtscreen")) nxl+=$1;
    nj++;
    if (match($2,"abrams")) {myj++;}
  }
  else
  {
    badhost=$8;
  }
}
END{
# don't forget the last host!
    host=newhost;
    ncpu=newncpu;
    spd=newspd;
    rcs=(s<5?"BGCOLOR=#00ff00":(nss>10?"BGCOLOR=#ff0000":(nxl>1?"BGCOLOR=#ff00dd":"")));
    mys="";
    if (myj>0)
	mys=sprintf("<sup><font size=1 color=11ddee>(%ic)</font></sup>",myj);
    printf(dlf,rcs,host,ncpu,spd,s/100,nj,mys);
}

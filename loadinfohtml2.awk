BEGIN{
  host="";
  s=0.0;
  nss=0.0;
  nxl=0.0;
  nj=0;
  ncpu=0;
  spd=0;
  rcs="";
  mys="";
  myj=0;
  dlf="<tr ALIGN=CENTER %s><td>%s</td><td>%s</td><td>%s</td><td>%.2f</td><td>%i</td><td>%s</td>\n"
  stanza=0;
  MAXUSERS=50;
  for (i=0;i<MAXUSERS;i++) userload[i]=0.0;
  clearStringArray(userlist);
  clearStringArray(cpuuserlist);
  u=0;
  VARDIR="/people/thnfs/homes/abrams/var";
}
{
  if (!match($1,"%"))
  {
  if (match($1,"#")) # closing a stanza
  {
    #printf("closing stanza %i\n",stanza);
    processStanza(stanza,host,ncpu,spd,s/100.,nj,cpuuserlist);
    host="";
    ncpu=spd=s=nj=myj=nss=nxl=0;
    clearStringArray(cpuuserlist,MAXUSERS);
    stanza++;
    # read info from current stanza-opening line
    if (!match($2,"ssh")) # good line
    {
      host=substr($1,2);
      ncpu=$2;
      spd=$4;
      #printf("good data: host %s n %i spd %i\n",host,ncpu,spd);
    }
    else # line for unreachable host
    {
      host=$8;
    }
  }
  else # reading a job data line in current stanza
  {
    s+=$1; # load for this job increments load for this host
    nj++;  # increment the number of jobs for this host
    # 4th column is the executable name of the job
    # the load for the job may be partitioned according
    # to its name
    if (match($4,"etscape")) nss+=$1;
    if (match($4,"xlock")||match($4,"dtscreen")) nxl+=$1;
    # 2nd column is the user id of the job owner
    u=addToUserList($2,cpuuserlist);
    u=addToUserList($2,userlist);
    userload[u]+=$1/100.;
    #userjobs[u]++;
    #for (i=1;i<=u;i++) printf("ul %i `%s'\n",i,userlist[i]);
    # if (match($2,"abrams")) myj++;
  }
  }
}
END{
# process the last stanza
  processStanza(stanza,host,ncpu,spd,s/100.,nj,cpuuserlist);
# update the individual users' cpu load trace files
  today=sprintf("%s",strftime("%d/%m/%Y.%H:%M"));
  for (i=1;userlist[i]!="";i++) 
  {
    fn=sprintf("%s/people/%s",VARDIR,userlist[i]); 
    printf("%s %.2f\n",today,userload[i])>>fn;
  }
}

function processStanza (stanza,host,ncpu,spd,load,njobs,userlist)
{
  if (stanza>0) #printf("nothing to process\n");
  #else
  {
    #printf(">> process: host %s n %i spd %i load %.2f\n",host,ncpu,spd,load);
    userstr="";
    for (i=1;userlist[i]!="";i++) userstr=sprintf("%s %s",userstr,userlist[i]);
    if (userstr=="") userstr=sprintf("none");
    #printf(">> users on host %s: %s\n",host,userstr);
    if (ncpu==0) # this is an unreachable host
    {
       printf(dlf,"BGCOLOR=#777777",host,0,0,0.0,0,"");
    }
    else
    {
      rcs=(s<5?"BGCOLOR=#00ff00":(nss>10?"BGCOLOR=#ff0000":(nxl>1?"BGCOLOR=#ff00dd":"")));
      printf(dlf,rcs,host,ncpu,spd,s/100,nj,userstr);
    }
  }
}

function addToUserList ( user, userlist )
{
  #printf(">> adding user `%s' to userlist\n", user);
  for (i=1;userlist[i]!=""&&!match(userlist[i],user);i++)
  {
    #printf(">> skipping list member `%s'...\n",userlist[i]);
  }
  if (userlist[i]=="") userlist[i]=user;
  return i;
}

function clearStringArray(a,N)
{
  for (i=0;i<N;i++) a[i]="";
}

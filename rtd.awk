# 
# rtd.awk
#
# rtd accepts input from the rtd tcsh script that
# produces the following output, one line per trajectory
#
# traj# (count-ion-carbons) (ion-carbon-ids) (count-ion-fs) (ion-f-ids) (count-sputtered-atoms) (list of sputtered atom ids)
#
# this awk script computes the residence time (in # of impacts)
# for each carbon and fluorine atom of the ion, and builds
# a residence time distribution function from this information
#
#
# (c) 1999 cameron abrams
#
# note -- this runs EXTREMELY SLOWLY
# better to use a compiled version written in C.
#
#
BEGIN{
  printf("# rtd.awk initializing...\n");
  fflush(stdout);
  cg=1; 		# default is no coarse-graining
  NBINS=1000;
  NDATA=4000;
  MXAPERI=5;
  MXY=50;
  for (i=1;i<=NDATA;i++)
  {
     nci[i]=nfi[i]=ns[i]=0;
     for (j=1;j<=MXAPERI;j++)
     {
        c[i,j]=f[i,j]=0;
     }
     for (j=1;j<=MXY;j++)
     {
        s[i,j]=0;
     }
   }
   printf("# rtd.awk reading...\n");
   fflush(stdout);
   ndata=0;
}
{
   i=1;
   n=$i;
   i++;
   nci[n]=$i;
   i++;
   for (j=1;j<=nci[n];j++) 
   {
	c[n,j]=$i;
	i++;
   }
   nfi[n]=$i;
   i++;
   for (j=1;j<=nfi[n];j++) 
   {
	f[n,j]=$i;
	i++;
   }   
   ns[n]=$i;
   i++;
   for (j=1;j<=ns[n];j++) 
   {
	s[n,j]=$i;
	i++;
   }
   ndata++;
   printf("# %i %i %i %i\n",n,nci[n],nfi[n],ns[n]);
   fflush(stdout);
}
END{
   printf("# rtd.awk read %i lines.\n",ndata);
   printf("# rtd.awk tabulating residence times...\n");
   for (i=1; i<=NBINS; i++) 
   {
     cbin[i]=fbin[i]=0;
   }
   cads=fads=0;

#   trace each carbon and fluorine from the ion until a match is found 
#   in the sputtered id's.
    for (n=1;n<=ndata;n++)
    {
	# for each carbon
        for (ci=1;ci<=nci[n];ci++)
	{
	    id=c[n,ci];
	    tid=id;
            cif=0;
            # search the sputtered ids for this id, and
	    # for each sputtered id that is LESS THAN this id,
 	    # decrement a copy of this id to be used on the NEXT
	    # comparison 
	    for (k=n;k<=ndata&&!cif;k++)
	    {
	        for (ks=1;ks<=ns[k]&&s[k,ks]!=id;ks++) 
		    if (s[k,ks]<id) tid--;
	        if (s[k,ks]==id) cif=1;
	        else id=tid;
	    }
	    if (cif) 
	    {
		cbin[k-n+1]++;
	    }
	    else 
	    {
		cads++;
	    }
	}
	# for each fluorine
        for (fi=1;fi<=nfi[n];fi++)
	{
	    id=f[n,fi];
	    tid=id;
            fif=0;
            # search the sputtered ids for this id, and
	    # for each sputtered id that is LESS THAN this id,
 	    # decrement a copy of this id to be used on the NEXT
	    # comparison 
	    for (k=n;k<=ndata&&!fif;k++)
	    {
	        for (ks=1;ks<=ns[k]&&s[k,ks]!=id;ks++) 
		    if (s[k,ks]<id) tid--;
	        if (s[k,ks]==id) fif=1;
	        else id=tid;
	    }
	    if (fif) 
	    {
		fbin[k-n+1]++;
	    }
	    else 
	    {
		fads++;
	    }
	}
    }
#   output the rtds, course grained according to value of cg
    ctot=ftot=0;
    for (i=1;i<=NBINS;i++) ctot+=cbin[i];
    for (i=1;i<=NBINS;i++) ftot+=fbin[i];
    printf("# total **sputtered** c %i f %i -- adsorbed c %i f %i -- total: c %i f %i\n", 
	ctot,ftot,cads,fads,ctot+cads,ftot+fads);
    ccum=fcum=0.0;
    for (i=1;i<=NBINS;i+=cg)
    {
	csum=0.0;
	for (j=0;j<cg;j++) csum+=((i+j)<2000)?cbin[i+j]:0;
        ccum+=sum/cg/ctot; 
	fsum=0.0;
	for (j=0;j<cg;j++) fsum+=((i+j)<2000)?fbin[i+j]:0;
        fcum+=sum/cg/ctot; 
	if (csum||fsum) 
	    printf("%i %i %.6f %i %.6f\n",i,cbin[i],csum/cg,fbin[i],fsum/cg);
    }
}

# des.awk
# 
# md series 2
#
# des.awk accepts output directly from clu.awk to
# produce the master sputdat file for a dataset.
#
# The output is a single line of 9+NCAT*NCLASS columns,
# which summarizes the .clu file that clu.awk processed
# in a form that identifies all molecular classes and
# categories present in that .clu file.  The first 9 columns
# are counts of each element that is (a) reflected, (b) physically
# sputtered, and (c) thermally desorbed.  (3 elements, 3 counts ->
# 9 columns).
#
# The array parameters cionstr and fionstr contain
# the id numbers of the atoms in the ion for
# the current trajectory.  A molecule's 'category'
# partially depends on how many of each kind of ion
# atom are present in the molecule, so the list of
# ion atom id's is required input to des.awk.
#
# Its most important function is determining the
# 'category' a given molecule belongs to.
#
# (c) 1999 cameron abrams
#
BEGIN{
MAXAMOL=100
NCAT=10;
NCLASS=31;

for (i=1;i<=NCLASS;i++) for (j=1;j<=NCAT;j++)  line[i,j]=0;
ncion=split(cionstr,cion);
nfion=split(fionstr,fion);
rfy=0;
rcy=0;
sfy=0;
scy=0;
dfy=0;
dcy=0;
ssiy=0;
dsiy=0;
}
{   
    for (i=1;i<=MAXAMOL;i++) 
    { 
	molid[i]=0;
        ccom[i]=0;
        fcom[i]=0;
    }
    nccom=0;
    nfcom=0;
    class=$1;
    apparentname=$2;
    be=$3;
    nf=$4;
    nc=$5;
    nsi=$6;
    nmolid=0;
    for (i=7;i<=NF;i++) { nmolid+=1; molid[nmolid]=$i; }
    nccom=intersect(cion,ncion,molid,nmolid,ccom);
    nfcom=intersect(fion,nfion,molid,nmolid,fcom);

    # given the class, binding energy, and the number of intersection,
    # determine which category this molecule belongs to.
    category=0;
    if (nc||nf||nsi) 
    {
	if (be>=0.0)
	{
	   if (nccom==0&&nfcom==0) # `physically sputtered`
	       category=1;
	   else if ((nccom+nfcom)==nmolid) # `physically reflected`
	       category=3;
	   else if (nccom==0&&nfcom>0) # `physically F-abstracted`
	       category=5;
	   else if (nccom>0&&nfcom==0) # `physically C-abstracted`
	       category=7;
	   else if (nccom>0&&nfcom>0) # `physically CF-abstracted`
	       category=9;
	}
	else
	{
	  if (nccom==0&&nfcom==0) # `thermally sputtered`
	       category=2;
	   else if ((nccom+nfcom)==nmolid) # `thermally reflected`
	       category=4;
	   else if (nccom==0&&nfcom>0) # `thermally F-abstracted`
	       category=6;
	   else if (nccom>0&&nfcom==0) # `thermally C-abstracted`
	       category=8;
	   else if (nccom>0&&nfcom>0) # `thermally CF-abstracted`
	       category=10;
	}
    }
    if (category==3||category==4) { rfy+=nf; rcy+=nc; rsiy+=nsi; }
    else if (category%2) { sfy+=nf; scy+=nc; ssiy+=nsi; }
    else { dfy+=nf; dcy+=nc; dsiy+=nsi; }
    if (dbg)
    {
    printf("# dbg-000 (des) class(%i) be(%.5f) nf(%i) nc(%i) nsi(%i) cat(%i)\n",
        class,be,nf,nc,nsi,category);
    arrayout("# cion",cion,ncion);
    arrayout("# fion",fion,nfion);
    arrayout("# molid",molid,nmolid);
    arrayout("# ccom",ccom,nccom);
    arrayout("# fcom",fcom,nfcom);
    }
    line[class,category]++;
}

END{
    printf("%i %i %i %i %i %i %i %i %i ",
	rfy,rcy,rsiy,sfy,scy,ssiy,dfy,dcy,dsiy);
    for (i=1;i<=NCLASS;i++) for (j=1;j<=NCAT;j++) printf("%i ",line[i,j]);
    printf("\n");
}

# intersect compares two arrays, and returns the number
# of elements in the intersection. 
# The intersection is placed in array com.
function intersect(array1,n1,array2,n2,com,    ncom) {
    ncom=0;
    for (i=1;i<=n1;i++)
    {
        for (j=1;j<=n2;j++)
        {
            if (array1[i]==array2[j])
            {
                ncom+=1;
                com[ncom]=array1[i];
  	    }
	}
    }
    return ncom;
}

function arrayout (label,array,n){
    printf("%s ",label);
    for (i=1; i<=n; i++) printf("%i ",array[i]);
    printf("\n");
}

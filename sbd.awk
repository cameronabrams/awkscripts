# sbd.awk
# 
# md series 2
#
# sbd.awk accepts streaming output from the operation of
# clu.awk onto a concatenated input of .clu data files.
# 
# sbd.awk produces a table giving the breakdown of 
# sputtered species by molecule class, included the
# numbers of each kind of atom sputtered in each class.
# This information is valuable since some classes are
# defined as "lumps" of many different molecules and
# therefore don't have a specific stoichiometry or 
# empirical formula.
#
# This breakdown summarizes the all the sputters found
# in the list of clu files operated on without regard
# to molecule 'category' -- i.e. whether the molecule
# is a reflection or sputter or abstraction, and whether
# the molecule is physically or thermally desorbed.  This more
# detailed information is determined by des.awk, which 
# produces the master 'sputdat' file.
#
# To produce such a 'breakdown' table for a dataset 
# that owns the .clu files "clu/????.clu", issue the following 
# command:
# % awk -f clu.awk -f class.awkf clu/????.clu | awk -f sbd.awk -f class.awkf
# 
# or, if 'clu/????.clu' expands into a argument list that's too long, then
# use 'echo' and 'xargs' like so:
# % echo clu/????.clu | xargs awk -f clu.awk -f class.awkf | awk -f sbd.awk -f class.awkf
#
#
# (c) 1999 cameron abrams
#
BEGIN{
    NCLASS=31;
    for (i=1;i<=NCLASS;i++)
    {
        molcnt[i]=0;
        fcnt[i]=0;
        ccnt[i]=0;
        sicnt[i]=0;
    }
    init_classnames(classnames);
}
/#N/{ N=$2; }
/[^#]/{
    # parse the input line from clu.awk
    class=$1;
    molcnt[class]++;
    fcnt[class]+=$4;
    ccnt[class]+=$5;
    sicnt[class]+=$6;
}
END{
    molsum=fsum=csum=sisum=0;
    for (i=1;i<=NCLASS;i++)
    {
        molsum+=molcnt[i];
        fsum+=fcnt[i];
        csum+=ccnt[i];
        sisum+=sicnt[i];
    }
    printf("#N %i\n",N);
    printf("#Total\t%i\t\t%i\t\t%i\t\t%i\n",
                molsum,fsum,csum,sisum);
    printf("#Class\tCount\tFrac\tFCount\tFFrac\tCCount\tCFrac\tSiCount\tSiFrac\n");
    for (i=1;i<=NCLASS&&(i==1||!match(classnames[i-1],"other"));i++)
    {
 	printf("%s\t%i\t%.5f\t%i\t%.5f\t%i\t%.5f\t%i\t%.5f\n",
		classnames[i],molcnt[i],molcnt[i]/molsum,
		fcnt[i],fsum?fcnt[i]/fsum:0,ccnt[i],csum?ccnt[i]/csum:0,
		sicnt[i],sisum?sicnt[i]/sisum:0);
    }
}

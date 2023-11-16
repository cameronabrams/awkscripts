# clu.awk
# 
# Operates on an md series 2 format .clu data file, or a
# streaming input of concatenated .clu data files.
# This data file format contains raw information on
# sputtered/desorbed molecular clusters.
# clu.awk condenses this raw data into one-molecule-
# per-line output.  Its most important function is
# assigning the 'class' of a molecule.  Molecule
# 'classes' are described in the function file 'class.awkf'.
#
# (c) 1999 cameron abrams
#
BEGIN{
    NCLASS=31;
    mols=0;
    init_classnames(classnames);
}
{
   # Test the input line to see if it is the beginning of a molecule
   if (match($1,"%")&&match($2,"Cluster")&&match ($3,"Trash"))
   {
	if (mols) printf("\n");
	mols=1;
        c="0";
        f="0";
        si="0";
        # Establish the empirical formula of the molecule
    	for (i=1;i<=NF;i++) 
        {
	    if (match($i,"F_")) f=$i;
            else if (match($i,"C_")) c=$i;
	    else if (match($i,"Si_")) si=$i;
        }
	# The last field on the line is the binding energy of the molecule
        be=$NF;
        # Strip the leading characters from the stoichiometries
        gsub("F_","",f);
        gsub("C_","",c);
	gsub("Si_","",si);
	# assign the molecule's class based on its empircal formula
        class=molclass(f,c,si);
        printf("%i %s %.5lf %i %i %i ",class,classnames[class],be,f,c,si);
    }
    else if ($1==int($1))  # a line that begins with an integer is atom data
        printf("%i ",$1);
    else
    {   if (mols) printf("\n");
        mols=0;
    }
}

END{printf("#Nfiles %i\n",ARGC-1);}

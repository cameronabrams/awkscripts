# clu-com.awk
# 
# Operates on an md series 2 format .clu data file, or a
# streaming input of concatenated .clu data files.
# This data file format contains raw information on
# sputtered/desorbed molecular clusters.
# clu-com.awk condenses this raw data into one-molecule-
# per-line output.  The output consists of
# (1) the molecule name
# (2) the molecule class
# (3) the molecule's center-of-mass velocity vector
# (4) the molecule's kinetic energy (based on the c.o.m. velocity)
# (5) the molecule direction polar angle, in degrees
#
# (c) 2000 cameron abrams
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
	#initialize the molmass and com vel vector components
	molmass=0.0;
	comvx=comvy=comvz=0.0;
    }
    else if ($1==int($1))  # a line that begins with an integer is atom data
    {
        # field 2 is the atom type
	mass=0.0;
	if (match($2, "Si")) mass=28.085;
	if (match($2, "C"))  mass=12.011;
	if (match($2, "F"))  mass=18.998;
	if (!mass) printf("error -- could not assign mass to %s\n", $2);
	mass*=1.036477518e-4;  # convert from amu to eV-ps^2/A^2
	molmass+=mass;
	vx=$6; vy=$7; vz=$8;   # 6, 7, 8 are the velocity vector components
			       # in Ang/ps
	comvx+=mass*vx;
	comvy+=mass*vy;
	comvz+=mass*vz;
    }
    else
    {   if (mols)   # end of molecule read -> output results for this molecule
	{
	    comvx/=molmass;
	    comvy/=molmass;
	    comvz/=molmass;
	    vmag=sqrt(comvx*comvx+comvy*comvy+comvz*comvz);
	    vmagxy=sqrt(comvx*comvx+comvy*comvy);
	    ke=0.5*molmass*vmag*vmag;	# KE in eV
	    # compute angle made by this vector and the +z-axis
	    pol=180/3.1415927*(3.1415927/2.0-atan2(comvz, vmagxy));
	    printf("%i %s %.5lf %.5lf %.5lf %.5lf %.5lf %.5lf\n",
		class,classnames[class],be,comvx,comvy,comvz,ke,pol);
	}
        mols=0;
    }
}

END{printf("#Nfiles %i\n",ARGC-1);}

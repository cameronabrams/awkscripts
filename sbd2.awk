# sbd2.awk operates on output of sbd.awk
# the 'count' columns are divided by N to give yields.

BEGIN{
}

/^#N/ {N=$2; print $0}
/^#Total/ {mols=$2; f=$3; c=$4; si=$5; print $0;
	printf("#Mol\tYield\tTFrac\tFYield\tFFrac\tCYield\tCFrac\tSiYield\tSiFrac\n");}
/^[^#]/{printf("%s\t%.4lf\t%.4lf\t%.4lf\t%.4lf\t%.4lf\t%.4lf\t%.4lf\t%.4lf\n",
	$1,$2/N,$3,$4/N,$5,$6/N,$7,$8/N,$9);}

END{
   printf("#sdb2 finished.\n");
}

BEGIN{s0=0;t0=0.0;output=0;s=0;t=0.0;te=0.0;pe=0.0;ke=0.0;nbe=0.0;ae=0.0;toe=0.0;hde=0.0;
#printf("#step time totalE potentialE kineticE nonbondE angE torE hdE\n");}
printf("#time totalE potentialE kineticE nonbondE angE torE hdE\n");}
/Step/{s=$2;newstep=1;}
/Simulated time/{t=$3;}
/Total energy/{te=$4; if (te==0.0) te=$3;}
/Potential energy/{pe=$4; if (pe==0.0) pe=$3;}
/Kinetic energy/{ke=$4; if (ke==0.0) ke=$3;}
/Nonbonded energy/{nbe=$4; if (nbe==0.0) nbe=$3;}
/Angle energy/{ae=$4; if (ae==0.0) ae=$3;}
/Torsion energy/{toe=$4; if (toe==0.0) toe=$3;}
/Harmonic dihedral energy/{hde=$5; if (hde==0.0) hde=$4;output=1;}
{if (output&&newstep) {
#   print s+s0,t+t0,te,pe,ke,nbe,ae,toe,hde;
   print t+t0,te,pe,ke,nbe,ae,toe,hde;
   output=0;
   newstep=0;
 }
}

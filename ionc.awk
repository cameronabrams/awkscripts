BEGIN{
  sx=sy=sz=0.0;
  i=0;
}
{ 
  id=$1;
  sym=$2;
  rx=$3;
  ry=$4;
  rz=$5;
  vx=$6;
  vy=$7;
  vz=$8;
  f=$9;
  printf("IonAtomPos %i %.10e %.10e %.10e\n",
    	i,rx-sx,ry-sy,rz-sz);
  printf("IonAtomVel %i %.10e %.10e %.10e\n",
    	i,vx,vy,vz);
  i++;
}

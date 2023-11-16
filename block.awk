BEGIN{N=5;n=0;i=0;for (i=1;i<=100;i++) {
	val[i]=0.0; 
	sqval[i]=0.0;
      }
  fmt="%.10e"; forward=1;}
{
  if (NF<100) {
    for (i=1;i<=NF;i++) {
      val[i]+=$i;
      sqval[i]+=$i*$i;
    }
    if (!n) saved=$1;
    n++;
    if (n==N) {
      if (forward==1) {
	printf("%s ",saved);
	for (i=2;i<=NF;i++) printf(fmt" sd-> "fmt" <-sd  ",val[i]/N,((sqval[i]-val[i]*val[i]/N)/N));
      }
      else for (i=1;i<=NF;i++) printf(fmt" sd-> "fmt" <-sd  ",val[i]/N,((sqval[i]-val[i]*val[i]/N)/N));
      printf("\n");
      n=0;
      for (i=1;i<=100;i++) val[i]=sqval[i]=0.0
    }
  }
}

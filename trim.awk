BEGIN{
  i=0;
}
{ for (i=1;i<(NF);i++) printf("%s%s",$i,i<(NF-1)?FS:"");}
END{
  printf("\n");
}

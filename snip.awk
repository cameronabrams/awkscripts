BEGIN{
  bf="{";  ef="}";
  b_open=0;
  b_n=0;
  sense=1;
  i=0;
  gotit=0;
}
{
 gotit=0;
 if (!b_open) 
 {
  for (i=1;i<=NF&&!match($i,bf);i++); 
  if (i<=NF) 
  {
    b_open=1; gotit=1;
    print $0, ">> b_number ",b_n;
  }
 }
 else 
 {
  for (i=1;i<=NF&&!match($i,ef);i++); 
  if (i<=NF) 
  {
     b_open=0; gotit=1;
     print $0, ">> b_number ",b_n;
     b_n++;
  }
 }
}
{if (!gotit && b_open && sense) print $0;
 if (!gotit && !b_open && !sense) print $0;}

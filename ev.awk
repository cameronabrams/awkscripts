BEGIN{
  ev=1;
  off=0;
  i=0;
  on=0;
}
{ if (!on&&i==off) {on=1;i=0}; i++; if (i==ev) i=0; if (on&&(!i)) print $0;} 

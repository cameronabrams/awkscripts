# weedxy.awk
#
# given a set of x vs. y data, removes data
# such that log_10(x_i)-log_10(x_{i-1}) is
# never less than a certain amount.  This
# can be used for plotting data with 
# a constant, or small, x spacing on a log-log
# plot so that the points aren't crowded near
# high x.
#
# (c) 2000 cam abrams
#
BEGIN{dl=0.05;ttx=0;tlx=0;begun=0;fac=1.0/log(10.);}
{
  if (!begun)
  {
    tlx=fac*log($1);
    begun=1;
    print $0;
  }
  else
  {
    ttx=fac*log($1);
    if ((ttx-tlx)>dl)
    {
      print $0;
      tlx=ttx;
    }
  }
}


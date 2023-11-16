BEGIN{F=0;NAT=0;M=0;N=0;f=0;nat=0;m=0;n=0;x=y=z=xp=yp=zp=0.0;i=j=k=l=0;b=0.0;bonds=0;}
                       {if(nat==0) printf("%d %d\n",NAT,bonds?M*(N-1):0);
		        x=$1;y=$2;z=$3;
			xp=x-box*int(x/box); yp=y-box*int(y/box); zp=z-box*int(z/box);
                        nat++;printf("6 %f %f %f\n",xp,yp,zp);
			if (nat==NAT) {
			  nat=0;
			  j=1;
			  if (bonds) for (i=0;i<NAT;i++) {
			    if ( (i+1)%NAT ) {
				printf("%d %d 0 0 1 0.7 20 0.1\n",i+1,i+2);
				j++;
                            }
                         }
                         }
                        }

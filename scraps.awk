   # build three lists:
   # (1) fnost = list of all F atom id's in the clu file
   # (2) cnost = list of all C atom id's in the clu file
   # (3) sispts = list of all Si atom id's in the clue file
   set fnost=(`grep -v '#\|%' clu/${n}.clu | grep F | awk '{print $1}'`)
   set cnost=(`grep -v '#\|%' clu/${n}.clu | grep C | awk '{print $1}'`)
   set sispts=(`grep -v '#\|%' clu/${n}.clu | grep Si | awk '{print $1}'`)
   echo dbg-001: fnost\(${fnost}\) cnost\(${cnost}\) sispts\(${sispts}\)

   # Segregate the list of no-stick fluorine (fnost) into two lists:
   # fref == list of fluorines that are in both the ion and sputters
   #       these are 'reflected' fluorine
   # fspts == list of fluorines which are not from ion; these
   #       are 'sputtered' fluorine
   set fref=()
   foreach f ($fnost)
     foreach ionf ($fion)
        if ( $ionf == $f ) set fref=($fref $f)
     end
   end
   set fspts=()
   foreach f ($fnost)
     set fnd=0
     foreach rf ($fref)
       if ($rf == $f) set fnd=1
     end
     if ( ! $fnd ) set fspts=($fspts $f)
   end
   # the yield of F is the number of sputtered F
   set yf=`echo $fspts | awk '{print NF}'`
   echo dbg-002: fspts\(${fspts}\) fref\(${fref}\) yf\($yf\)

   # For each F atom that is a confirmed sputter, determine what "class" of molecule
   # it resides in, and increment the bin for this class.  The "class" of a molecule
   # depends on its empirical formula, so we must parse a given molecule name
   # to determine that formula.
   foreach f ($fspts)
     # extract the molecule name for this sputter from the clu file.
     set mol=(`grep -B100 ^$f clu/${n}.clu | grep '^% Cluster' | tail -1 | awk -f cmatch.awk c=_`)
     # parse the molecule name to obtain the number of F,C,and Si in the molecule,
     # i.e., the empirical formula of the molecule
     set nf=`echo $mol | awk -f cmatch.awk c=F | sed s/F_//`
     set nc=`echo $mol | awk -f cmatch.awk c=C | sed s/C_//`
     set nsi=`echo $mol | awk -f cmatch.awk c=S | sed s/Si_//`
     if ( "$nf" == "" ) set nf=0
     if ( "$nc" == "" ) set nc=0
     if ( "$nsi" == "" ) set nsi=0
     set class=`echo $nf $nc $nsi | awk -f molclass.awk`
     echo dbg-003 mol\($mol\) nf\($nf\) nc\($nc\) nsi\($nsi\) class\($class\)
   end

   # Segregate the list of no-stick carbon (cnost) into two lists:
   # cref == list of carbons that are in both the ion and sputters
   #       these are 'reflected' carbon
   # cspts == list of carbons which are not from ion; these
   #       are 'sputtered' carbon
   set cref=()
   foreach c ($cnost)
     foreach ionc ($cion)
        if ( $ionc == $c ) set cref=($cref $c)
     end
   end
   set cspts=()
   foreach c ($cnost)
     set fnd=0
     foreach rc ($cref)
       if ($rc == $c) set fnd=1
     end
     if ( ! $fnd ) set cspts=($cspts $c)
   end
   # the yield of C is the number of sputtered C
   set yc=`echo $cspts | awk '{print NF}'`
   echo dbg-003: cspts\(${cspts}\) cref\(${cref}\) yc\($yc\)



   set ysi=`echo $sispts | awk '{print NF}'`
   # echo dbg-005: sispts\(${sispts}\) ysi\(${ysi}\)
   set ysi=`echo $ysi - 0 | bc`
   # echo dbg-006: msi\(0\) ysi\(${ysi}\)

   set TOT=`echo $yc+$yf+$ysi | bc`
   echo $n ${yc} ${yf} ${ysi} $TOT

/* Pivot text file wide to long using SAS INFILE/INPUT.
   Extracted verbatim from the SAS solution in
   utl-pivot-text-file-wide-to-long-using-sas-infile-and-r.sas
   (the "SAS (more readable and transferable)" solution). */

data want;
  retain idg;
  input group $2. code $4. ids $44. ;

  * CONVERT WHAT USED TO BE A LINE BREAK TO A COMMA;
  ids=tranwrd(ids,'\n',',');

  * IF A NEW LINE STARTS WITH I THEN WE HAVE NO G# SET G# TO 'NA';
  line=_n_;
  if ids=:'i' then idg="NA";

  * DO THE SPLITS;
  do i=1 to countc(ids,',')+1;
    idcut=scan(ids,i,',');
    select;
       when (idcut=:'g') do;
           idg=scan(idcut,1,':');
           idi=scan(idcut,2,':');
       end;
       when (idcut=:'i') idi=idcut;
    end;
    * LEAVE OFF OTHERWISE TO FORCE ERROR IF NOT EXCLUSIVE;
    output;
  end;

  keep group code idi idg;
cards4;
A 101 g1:id1,id2,id3\ng2:id4,id5
B 102 id6,id7,id8,id9
C 103 g1:id10,id11\ng3:id12
D 104 g2:id13,id14
E 105 id15
;;;;
run;quit;

proc print data=want;
var group code idi idg;
run;quit;

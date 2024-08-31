# utl-pivot-text-file-wide-to-long-using-sas-infile-and-r
Pivot text file wide to long using sas infile input and R 
    %let pgm=utl-pivot-text-file-wide-to-long-using-sas-infile-and-r;

    Pivot text file wide to long using sas infile input and R

    github
    https://tinyurl.com/2s8a4z34
    https://github.com/rogerjdeangelis/utl-pivot-text-file-wide-to-long-using-sas-infile-and-r

    SOAPBOX ON

      Two Solutions

         1  SAS (more readable and transferable to another language)
            (Fast was based on  IBM PL/1 (meant to be the only language you will ever need)
             There was a rumor around IBM as PL/1 was being developed.
             A pschychaitrist was brought in to review the 1000 of pages of design 'fights'
             too help the developers speed up decision making.

         2  R (soltion uses unique R syntax. Maybe R should not try to be a preceedural language)
            Do we really need the sytax below (do other languages have this syntax)

            Less is more - R and python(worse?) syntax is impossible for programmers to master, just too much of it,
            see solution delow

            R symtax
            separate_longer_delim
            too_few
            relocate
            .after

            https://stackoverflow.com/users/2835261/lroha

    SOAPBOX OFF


    stackoverflow
    https://stackoverflow.com/questions/78926853/separate-collapsed-column-into-multiple-rows-preserving-grouping-information


    /**************************************************************************************************************************/
    /*                                    |                                             |                                     */
    /*           INPUT                    |           PROCESS                           |           OUTPUT                    */
    /*                                    |                                             |                                     */
    /*                                    |                                             |                                     */
    /*  A 101 g1:id1,id2,id3\ng2:id4,id5  | 1. eol imdedded '\n' to comma               |  GROUP    CODE    IDI     IDG       */
    /*  B 102 id6,id7,id8,id9             | 2. scan usin ',' delimeter                  |                                     */
    /*  C 103 g1:id10,id11\ng3:id12       |    and split the text                       |    A      101     id1     g1        */
    /*  D 104 g2:id13,id14                |                                             |    A      101     id2     g1        */
    /*                                    | SAS(minor changes for another language)     |    A      101     id3     g1        */
    /*                                    | =======================================     |    A      101     id4     g2        */
    /*                                    |                                             |    A      101     id5     g2        */
    /*                                    | data want;                                  |    B      102     id6     NA        */
    /*                                    |                                             |    B      102     id7     NA        */
    /*                                    |  retain idg;                                |    B      102     id8     NA        */
    /*                                    |                                             |    B      102     id9     NA        */
    /*                                    |  input group $2. code $4. ids $44. ;        |    C      103     id10    g1        */
    /*                                    |                                             |    C      103     id11    g1        */
    /*                                    |  * CONVERT WHAT USED TO BE A                |    C      103     id12    g3        */
    /*                                    |    LINE BREAK TO A COMMA;                   |    D      104     id13    g2        */
    /*                                    |                                             |    D      104     id14    g2        */
    /*                                    |  ids=tranwrd(ids,'\n',',');                 |    E      105     id15    NA        */
    /*                                    |                                             |                                     */
    /*                                    |  * IF A NEW LINE STARTS WITH I              |                                     */
    /*                                    |    THEN WE HAVE NO G# SET G# TO 'NA';       |                                     */
    /*                                    |  line=_n_;                                  |                                     */
    /*                                    |  if ids=:'i' then idg="NA";                 |                                     */
    /*                                    |                                             |                                     */
    /*                                    |  * DO THE SPLITS;                           |                                     */
    /*                                    |  do i=1 to countc(ids,',')+1;               |                                     */
    /*                                    |    idcut=scan(ids,i,',');                   |                                     */
    /*                                    |    select;                                  |                                     */
    /*                                    |       when (idcut=:'g') do;                 |                                     */
    /*                                    |           idg=scan(idcut,1,':');            |                                     */
    /*                                    |           idi=scan(idcut,2,':');            |                                     */
    /*                                    |       end;                                  |                                     */
    /*                                    |       when (idcut=:'i') idi=idcut;          |                                     */
    /*                                    |    end;                                     |                                     */
    /*                                    |    * LEAVE OFF OTHERWISE TO                 |                                     */
    /*                                    |      FORCE ERROR IF NOT EXCLUSIVE;          |                                     */
    /*                                    |                                             |                                     */
    /*                                    |    output;                                  |                                     */
    /*                                    |  end;                                       |                                     */
    /*                                    |                                             |                                     */
    /*                                    |  keep group code idi idg;                   |                                     */
    /*                                    | cards4;                                     |                                     */
    /*                                    | A 101 g1:id1,id2,id3\ng2:id4,id5            |                                     */
    /*                                    | B 102 id6,id7,id8,id9                       |                                     */
    /*                                    | C 103 g1:id10,id11\ng3:id12                 |                                     */
    /*                                    | D 104 g2:id13,id14                          |                                     */
    /*                                    | E 105 id15                                  |                                     */
    /*                                    | ;;;;                                        |                                     */
    /*                                    | run;quit;                                   |                                     */
    /*                                    |                                             |                                     */
    /*                                    | proc print data=want;                       |                                     */
    /*                                    | var group code idi idg;                     |                                     */
    /*                                    | run;quit;                                   |                                     */
    /*                                    |                                             |                                     */
    /*------------------------------------|---------------------------------------------|-------------------------------------*/
    /*                                    |                                             |                                     */
    /*                                    | R                                           |                                     */
    /*                                    | =                                           |                                     */
    /*                                    |                                             |                                     */
    /*                                    | proc datasets lib=sd1 nodetails nolist;     | R                                   */
    /*                                    |  delete rwant;                              |                                     */
    /*                                    | run;quit;                                   |  # A tibble: 15 Ã— 4                */
    /*                                    |                                             |     group  code id    subgroup      */
    /*                                    | %utl_rbeginx;                               |     <chr> <int> <chr> <chr>         */
    /*                                    | parmcards4;                                 |   1 A       101 id1   g1            */
    /*                                    | library(tidyr)                              |   2 A       101 id2   g1            */
    /*                                    | library(dplyr)                              |   3 A       101 id3   g1            */
    /*                                    | source("c:/oto/fn_tosas9x.R");              |   4 A       101 id4   g2            */
    /*                                    |                                             |   5 A       101 id5   g2            */
    /*                                    | mydf <- data.frame(                         |   6 B       102 id6   <NA>          */
    /*                                    |   group=LETTERS[1:5], code=101:105          |   7 B       102 id7   <NA>          */
    /*                                    |  ,ids=c('g1:id1,id2,id3\ng2:id4,id5',       |   8 B       102 id8   <NA>          */
    /*                                    |  'id6,id7,id8,id9',                         |   9 B       102 id9   <NA>          */
    /*                                    |  'g1:id10,id11\ng3:id12',                   |  10 C       103 id10  g1            */
    /*                                    |  'g2:id13,id14',                            |  11 C       103 id11  g1            */
    /*                                    |  'id15'))                                   |  12 C       103 id12  g3            */
    /*                                    |                                             |  13 D       104 id13  g2            */
    /*                                    | want<-mydf |>                               |  14 D       104 id14  g2            */
    /*                                    |   separate_longer_delim(ids, "\n") |>       |  15 E       105 id15  <NA>          */
    /*                                    |   separate_wider_delim(ids, ":"             |                                     */
    /*                                    |     ,names = c("subgroup", "id")            | SAS                                 */
    /*                                    |     ,too_few = "align_end") |>              |                                     */
    /*                                    |   separate_longer_delim(id, ",") |>         | GROUP    CODE    IDI     IDG        */
    /*                                    |   relocate(subgroup, .after = last_col())   |                                     */
    /*                                    |                                             |   A      101     id1     g1         */
    /*                                    | want                                        |   A      101     id2     g1         */
    /*                                    |                                             |   A      101     id3     g1         */
    /*                                    | fn_tosas9x(                                 |   A      101     id4     g2         */
    /*                                    |       inp    = want                         |   A      101     id5     g2         */
    /*                                    |      ,outlib ="d:/sd1/"                     |   B      102     id6     NA         */
    /*                                    |      ,outdsn ="rwant"                       |   B      102     id7     NA         */
    /*                                    |      )                                      |   B      102     id8     NA         */
    /*                                    | ;;;;                                        |   B      102     id9     NA         */
    /*                                    | %utl_rendx;                                 |   C      103     id10    g1         */
    /*                                    |                                             |   C      103     id11    g1         */
    /*                                    | libname sd1 "d:/sd1";                       |   C      103     id12    g3         */
    /*                                    | proc print data=sd1.rwant;                  |   D      104     id13    g2         */
    /*                                    | var group code id subgroup;                 |   D      104     id14    g2         */
    /*                                    | run;quit;                                   |   E      105     id15    NA         */
    /*                                    |                                             |                                     */
    /**************************************************************************************************************************/

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */

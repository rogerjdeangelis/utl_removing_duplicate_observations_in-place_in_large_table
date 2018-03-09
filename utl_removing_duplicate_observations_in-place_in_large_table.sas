Removing duplicate observations in-place in large table

Same results WPS and SAS

github
https://tinyurl.com/yceka2xt
https://github.com/rogerjdeangelis/utl_removing_duplicate_observations_in-place_in_large_table

SAS Forum
https://tinyurl.com/ycslkdwp
https://communities.sas.com/t5/Base-SAS-Programming/Removing-duplicate-observations-in-place-in-large-datasets/m-p/443851

S Lassen Profile
https://communities.sas.com/t5/user/viewprofilepage/user-id/76464


INPUT  (Two tables)
====================

 * Table with a list of names that are duplicated;

 WORK.HAVDUP total obs=3

    NAME

   James
   Jane
   Louise


 * larger table with dup records;

 Remove duplicates names

 WORK.HAVE total obs=18

      NAME       SEX    AGE

      Alfred      M      14
      Alice       F      13
      Barbara     F      13
      Carol       F      14
      Henry       M      14

      James       M      12
      James       X     999   * remove

      Jane        F      12
      Jane        X     999   * remove

      Janet       F      15
      Jeffrey     M      13
      John        M      12
      Joyce       F      11
      Judy        F      14

      Louise      F      12
      Louise      X     999   * remove

      Mary        F      15
      Philip      M      16


PROCESS
=======

  data have;
    set havDup;
    first=1;
    do until(0);
      modify have key=name;
      if _iorc_ then do;
         _error_=0; /* when _iorc_ is set, an error is provoked */
         leave;
         end;
      if not first then
        remove;
      else
        first=0; /* the next obs is not the first */
      end;
  run;quit;


OUTPUT
======

 The WPS System

    Name       Sex    Age

    Alfred      M      14
    Alice       F      13
    Barbara     F      13
    Carol       F      14
    Henry       M      14
    James       M      12 ** only one (the first)
    Jane        F      12 ** only one (the first)
    Janet       F      15
    Jeffrey     M      13
    John        M      12
    Joyce       F      11
    Judy        F      14
    Louise      F      12 ** only one
    Mary        F      15
    Philip      M      16

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have(index=(name)) havDup(keep=name);
   set sashelp.class(obs=15 drop=height weight);
   output have;
   if uniform(5731) > .8 then do;
       sex='X';
       age=999;
       output havDup;
       output have;
   end;
run;quit;

*
 ___  __ _ ___
/ __|/ _` / __|
\__ \ (_| \__ \
|___/\__,_|___/

;

data have;
  set havDup;
  first=1;
  do until(0);
    modify have key=name;
    if _iorc_ then do;
       _error_=0; /* when _iorc_ is set, an error is provoked */
       leave;
       end;
    if not first then
      remove;
    else
      first=0; /* the next obs is not the first */
    end;
run;quit;

*
__      ___ __  ___
\ \ /\ / / '_ \/ __|
 \ V  V /| |_) \__ \
  \_/\_/ | .__/|___/
         |_|
;

%utl_submit_wps64('
libname wrk "%sysfunc(pathname(work))";
libname hlp "C:\Program Files\SASHome\SASFoundation\9.4\core\sashelp";
data have(index=(name)) havDup(keep=name);
   set hlp.class(obs=15 drop=height weight);
   output have;
   if uniform(5731) > .8 then do;
       sex="X";
       age=999;
       output havDup;
       output have;
   end;
run;quit;
data have;
  set havDup;
  first=1;
  do until(0);
    modify have key=name;
    if _iorc_ then do;
       _error_=0;
       leave;
       end;
    if not first then
      remove;
    else
      first=0;
    end;
run;quit;
proc print data=have;
run;quit;
');


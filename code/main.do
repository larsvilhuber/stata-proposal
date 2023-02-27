/* main.do */
/* Author: Lars Vilhuber */

include "config.do"
global DATADIR "${rootdir}/data"
global CODEDIR "${rootdir}/code"




/*============================= start code =========================*/

/* download data */
ssccount

describe

save "${DATADIR}/sscpackages", replace

/* keep only November 2022 */

keep if mo==tm(2022m11)

preserve
collapse (sum) npkghit
li
/* number of authors */

restore, preserve
collapse (sum) npkghit, by(author)
qui sum npkghit
di "There are `r(N)' authors."

/* top 10 (in reverse order) */

restore

sort npkghit

li in -10/L


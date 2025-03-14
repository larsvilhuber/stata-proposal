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

/* keep only January 2025 */

keep if mo==tm(2025m1)

preserve
sort package
bysort package: keep if _n==1
collapse (sum) npkghit
di "====== Total downloads of packages in this month ======="
li
di "========================================================"
/* top 30 (in reverse order) */
sort npkghit
li in -30/L


/* number of packages */
restore, preserve
sort package
collapse (sum) npkghit, by(package)
qui sum npkghit
di "There are `r(N)' packages"

/* number of authors */
restore, preserve
collapse (sum) npkghit, by(author)
qui sum npkghit
di "There are `r(N)' authors."


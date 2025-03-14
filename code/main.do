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
collapse (sum) npkghit
li

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

/* top 30 (in reverse order) */
restore
sort npkghit

li in -30/L


/* $Id: config.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/config.sas $ */
/* configuration */

%let bdsraw=/data/raw/bds/; /* on ECCO */
%let bdsces=../data/bds/; /* on CES research1 */
%let synces=../../../SynLBD/data/synlbd/2.0.1/; /* on CES research1 */
libname BDS ("&bdsraw.","&bdsces") access=readonly;
libname SynLBD ("&synces") access=readonly;
libname INTERNL ("../../../SynLBD/bds_synth") access=readonly;
libname INPUTS (BDS);
libname OUTPUTS "../data";
libname INTERWRK (OUTPUTS);

options sasautos=(!SASAUTOS, ".", "macros/" );

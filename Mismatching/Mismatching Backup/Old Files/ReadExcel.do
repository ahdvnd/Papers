/* do-file code to read Excel spreadsheets */

/* loop thru each of the Sheets beginning with Sheet4 */
forvalues i=4(-1)1 {

  /* capture the hospital name from cell A1 */
  import excel using hospital.xls, ///
         sheet(Sheet`i') cellrange(A1:A1) clear 
  local hname = A[1]    /* local macro with hospital name */
       
  /* get the data beginning in cell B2 */     
  import excel using hospital.xls, ///
         sheet(Sheet`i') cellrange(B2) firstrow clear 
  generate str12 hname = "`hname'"   /* create variable with hospital name */
  
  /* append and save data */
  if `i'==4 {
    save hospital, replace
  }
  else {
    append using hospital.dta
    save hospital, replace
  }
  
}

encode hname, gen(hnum)    /* create numeric hospital code */
order hname hnum           /* reorder data placing hospital name first */
save hospital, replace<    /* final save of the data */

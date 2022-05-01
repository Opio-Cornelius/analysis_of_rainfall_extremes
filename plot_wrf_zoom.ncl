;Plot WRF output with different resources

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 

begin
;---Open WRF output file
  a = addfile("~/result/objective2/e7/wrfout_d03_2008-03-16_00:00:00","r")
  b = addfile("~/result/objective2/e8/wrfout_d03_2008-03-16_00:00:00","r")
  c = addfile("~/result/objective2/e9/wrfout_d03_2008-03-16_00:00:00","r")


;---Read temperature at first time step
  r1c = wrf_user_getvar(a,"RAINNC",168)
  r2c = wrf_user_getvar(a,"RAINC",168)
  rainc = r1c + r2c
;  printVarSummary(rainc)
;  printMinMax(rainc, 0)

  r1e1 = wrf_user_getvar(b,"RAINNC",168)
  r2e1 = wrf_user_getvar(b,"RAINC",168)
  raine1 = r1e1 + r2e1

  r1e2 = wrf_user_getvar(c,"RAINNC",168)
  r2e2 = wrf_user_getvar(c,"RAINC",168)
  raine2 = r1e2 + r2e2

  wks = gsn_open_wks("png","wrf_e7_e8_e9")


; ------------ Zooming resources --------------------------------

  minlat =  -1.6
  maxlat =   1.15
  minlon =   29.1
  maxlon =  35.1

  lats = (/ minlat, maxlat /)
  lons = (/ minlon, maxlon /)
  loc  = wrf_user_ll_to_ij(a, lons, lats, True)
  loc  = wrf_user_ll_to_ij(b, lons, lats, True)
  loc  = wrf_user_ll_to_ij(c, lons, lats, True)

  loc = loc-1       ; Index values are returned as 1 to N, so we have to
                    ; subtract 1 for 0 to N-1 indexing that NCL requires.


;---Resources for filled contour plot-----------------------------
  
 res                      = True
 res@gsnDraw              = False
 res@gsnFrame             = False
 res@gsnMaximize          = True
 res@cnFillOn             = True  
 res@cnLinesOn            = False
 res@cnRasterSmoothingOn  = True
 res@cnLinesOn            = False
 res@cnLineLabelsOn       = False
 res@mpFillOn             = False
 res@mpCenterLonF         = 180
 res@cnLevelSelectionMode = "ExplicitLevels"
 res@cnLevels          = (/ 0, 10, 30, 60, 100, 120, 160, 200, 240, 280, 320/)
 
 res@cnFillPalette 		= "precip3_16lev"
 res@tfDoNDCOverlay             = True
 res@gsnAddCyclic         	= False    ; data is regional
 res@mpDataBaseVersion 		= "MediumRes"
 res@mpOutlineBoundarySets  	= "AllBoundaries"
 res@mpGeophysicalLineColor 	= "Black"
 res@mpNationalLineColor    	= "Black"
 res@mpGeophysicalLineThicknessF = 3.0
 res@mpNationalLineThicknessF 	= 3.0
 res@lbLabelBarOn          	= False
 res@pmLabelBarWidthF     	= 0.1
; res@tiMainFontHeightF    	= 1.0
 res@lbLabelFont     		= "times-roman"
 res@lbLabelFontHeightF 	= 0.013
; res@lbTitleOn        		= True 
; res@lbTitleString    		= "mm"
; res@lbTitleFontHeightF	= 0.012
 res@lbOrientation 		= "vertical"
 res@gsnLeftString       	= "Total Precipitation"
 res@pmTickMarkDisplayMode      = "Always"
 res@tmXBLabelFont		= "times-roman"
 res@tmYLLabelFont		= "times-roman"
 res@tmYLLabelFontHeightF       = 0.02
 res@tmXLLabelFontHeightF       = 0.02
 

; -------------------------------ZOOMING--------------------------------------------------
  
  res1        = res         ; Make copy of common resource list
  res1@ZoomIn = True        ; These five resources are required
  res1@Xstart = loc(0,0)    ; when zooming in on WRF data and
  res1@Xend   = loc(0,1)    ; keeping the same map projection.
  res1@Ystart = loc(1,0)
  res1@Yend   = loc(1,1)

  res1 = wrf_map_resources(a, res1)
  res1 = wrf_map_resources(b, res1)
  res1 = wrf_map_resources(c, res1)
  res1@tfDoNDCOverlay              = True     ; Tells NCL this is a native projection

;---Overwrite some of the resources set by wrf_map_resources.

  res1@mpNationalLineColor         = "black"
  res1@mpGeophysicalLineColor      = "black"
  res1@mpNationalLineThicknessF    = 3.0
  res1@mpGeophysicalLineThicknessF = 3.0

  plot1 = gsn_csm_contour_map(wks,rainc(loc(1,0):loc(1,1),loc(0,0):loc(0,1)),res1)
  plot2 = gsn_csm_contour_map(wks,raine1(loc(1,0):loc(1,1),loc(0,0):loc(0,1)),res1)
  plot3 = gsn_csm_contour_map(wks,raine2(loc(1,0):loc(1,1),loc(0,0):loc(0,1)),res1)

;------------ Panel resources -------------------------------------------------------------------
   pres                    = True
   pres@gsnMaximize        = True
   pres@gsnPanelLabelBar   = True
;   pres@lbLabelBarOn       = False
   pres@pmLabelBarWidthF   = 0.7
   pres@pmLabelBarHeightF  = 0.05
   pres@lbLabelFontHeightF = 0.008
   ;pres@lbOrientation 	   = "vertical"
   pres@lbLabelFont        = "times-roman"
   pres@lbLeftMarginF	   = 0.2
;  pres@lbTitleString      = "mm"
;  pres@lbTitleFontHeightF = 0.01


  gsn_panel(wks,(/plot1,plot2,plot3/),(/1,3/),pres)

end


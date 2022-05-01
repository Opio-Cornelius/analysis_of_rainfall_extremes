;Plot WRF output with different resources

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 

begin
;---Open WRF output file
  a = addfile("~/result/objective2/control/wrfout_d03_2008-03-16_00:00:00","r")

;---Read temperature at first time step
  r1 = wrf_user_getvar(a,"RAINNC",168)
  r2 = wrf_user_getvar(a,"RAINC",168)
  rain = r1 + r2
;  printVarSummary(rain)
;  printMinMax(rain, 0)

  wks = gsn_open_wks("png","wrf_control")


; ------------ Zooming resources --------------------------------

  minlat =  -1.6
  maxlat =   1.15
  minlon =   29.1
  maxlon =  35.1

  lats = (/ minlat, maxlat /)
  lons = (/ minlon, maxlon /)
  loc  = wrf_user_ll_to_ij(a, lons, lats, True)

  loc = loc-1       ; Index values are returned as 1 to N, so we have to
                    ; subtract 1 for 0 to N-1 indexing that NCL requires.


;---Resources for filled contour plot-----------------------------
  
 res                      = True
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
  res1@tfDoNDCOverlay              = True     ; Tells NCL this is a native projection

;---Overwrite some of the resources set by wrf_map_resources.

  res1@mpNationalLineColor         = "black"
  res1@mpGeophysicalLineColor      = "black"
  res1@mpNationalLineThicknessF    = 3.0
  res1@mpGeophysicalLineThicknessF = 3.0

  plot = gsn_csm_contour_map(wks,rain(loc(1,0):loc(1,1),loc(0,0):loc(0,1)),res1)

end


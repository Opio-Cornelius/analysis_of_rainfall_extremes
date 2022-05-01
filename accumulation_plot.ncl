; script for reading gpm daily accumulated rainfall in netcdf format

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 

 begin

 diri     = "~/result/objective2/plots/"         
 fil1     = "accum.nc"
 fil2     = "rain2008.nc"


; ***************Extract rainfall*********************

   f1        = addfile (diri+fil1, "r")         
   rain      = f1->TRMM_3B42_Daily_7_precipitation

   f2        = addfile (diri+fil2, "r")         
   LVB       = f2->TRMM_3B42_Daily_7_precipitation
   
;  printVarSummary(rain)
  printMinMax(rain, 0)
 

; ***********Plotting resources**********************

  wtype          = "png"
  wtype@wkWidth  = 1000     ; Set the pixel size of PNG image.
  wtype@wkHeight = 1000  
 wks = gsn_open_wks(wtype, "accumulation_20_day")

 res                      = True
 res@gsnMaximize          = True
 res@cnFillOn             = True
 res@cnFillMode           = "RasterFill"
 res@cnRasterSmoothingOn  = True
 res@cnLinesOn            = False
 res@cnLineLabelsOn       = False
 res@mpFillOn             = False
 res@mpCenterLonF         = 180
 res@cnLevelSelectionMode = "ExplicitLevels"
 res@cnLevels          = (/ 0, 40, 80, 120, 160, 200,\
                                     240, 280, 320/)
 
 res@cnFillPalette 		= "precip3_16lev"
 res@gsnAddCyclic         	= False    ; data is regional
 res@mpDataBaseVersion 		= "MediumRes"
 res@mpOutlineBoundarySets  	= "AllBoundaries"
 res@mpGeophysicalLineColor 	= "Black"
 res@mpNationalLineColor    	= "Black"
 res@mpGeophysicalLineThicknessF = 3.0
 res@mpNationalLineThicknessF 	= 3.0
 res@pmLabelBarWidthF     	= 0.1
; res@tiMainFontHeightF    	= 1.0
; res@lbLabelBarOn          	= False
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
 res@mpMinLatF            	= min(LVB&lat)
 res@mpMaxLatF            	= max(LVB&lat)
 res@mpMinLonF            	= min(LVB&lon)
 res@mpMaxLonF            	= max(LVB&lon)
; res@tfDoNDCOverlay       = True
 res@tmYLLabelFontHeightF       = 0.02
 res@tmXLLabelFontHeightF       = 0.02



; **********PLOT******************

 plot = gsn_csm_contour_map(wks, rain(:,:), res)

end



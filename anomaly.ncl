; script for plotting trmm daily rainfall anomaly

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 

 begin

 diri     = "~/result/anomalies/"         
 fil1     = "long_1998_2017_mam.nc"
 fil2     = "mam_2016.nc"
 fil3     = "mam_2017.nc"
 fil4     = "rain2008.nc"


; ***************Extract rainfall*********************

   f1        = addfile (diri+fil1, "r")         
   rain_long = f1->TRMM_3B43_7_precipitation
   sdev_long = stddev(rain_long)
   print(sdev_long)

   f2        = addfile (diri+fil2, "r")         
   rain_year1 = f2->TRMM_3B42_Daily_7_precipitation

   f3        = addfile (diri+fil3, "r")         
   rain_year2 = f3->TRMM_3B42_Daily_7_precipitation

   f4        = addfile (diri+fil4, "r")         
   LVB       = f4->TRMM_3B42_Daily_7_precipitation


; ************** Calculate Anomaly and assign it coordinates*****************

  anomaly1 = (rain_year1 - rain_long)/sdev_long
  anomaly2 = (rain_year2 - rain_long)/sdev_long
  
; printVarSummary (anomaly1)
; print(anomaly1)
  
  anomaly1@units = rain_year1@units
  copy_VarCoords(rain_year1, anomaly1)

  anomaly2@units = rain_year2@units
  copy_VarCoords(rain_year2, anomaly2)


; *********** Plot Anomaly **********************

 wtype          = "png"
 wtype@wkWidth  = 1000     ; Set the pixel size of PNG image.
 wtype@wkHeight = 1000  
 wks = gsn_open_wks(wtype, "anomaly_2016_2017")

 res                      = True
 res@gsnDraw              = False
 res@gsnFrame             = False
 res@gsnMaximize          = True
 res@cnFillOn             = True
 res@cnFillMode           = "RasterFill"
 res@cnRasterSmoothingOn  = True
 res@cnLinesOn            = False
 res@cnLineLabelsOn       = False
 res@mpFillOn             = False
 res@mpCenterLonF         = 180
 res@cnLevelSelectionMode = "ExplicitLevels"
 res@cnLevels          = (/-2.5, -2.25, -2, -1.75, -1.5, -1.25, -1, -0.75, -0.5, -0.25, 0, 0.15, 0.3, 0.45, 0.6, 0.75, 0.9, 1.05, 1.2, \
                                     1.35, 1.5, 1.65, 1.8/)
 
 res@cnFillPalette 		= "GMT_polar"
 res@gsnAddCyclic         	= False    ; data is regional
 res@mpDataBaseVersion 	= "MediumRes"
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
 res@mpMinLatF            	= min(LVB&lat)
 res@mpMaxLatF            	= max(LVB&lat)
 res@mpMinLonF            	= min(LVB&lon)
 res@mpMaxLonF            	= max(LVB&lon)

; Adjusting tickmark positions
;  res@tmYLValues = ispan(29,34,1)
;  res@tmXBValues = ispan(-1,1,1)

; Panel resources
   pres                    = True
   pres@gsnMaximize        = True
   pres@gsnPanelLabelBar   = True
   pres@pmLabelBarWidthF   = 0.07
   pres@pmLabelBarHeightF  = 0.18
   pres@lbLabelFontHeightF = 0.008
   pres@lbOrientation 	   = "vertical"
   pres@lbLabelFont        = "times-roman"
   pres@lbLeftMarginF	   = 0.2
;  pres@lbTitleString      = "mm"
;  pres@lbTitleFontHeightF = 0.01


; **********PLOT******************

 plot1 = gsn_csm_contour_map(wks, anomaly1(:,:), res)
 plot2 = gsn_csm_contour_map(wks, anomaly2(:,:), res)

; ****** Panel Plots **************
gsn_panel(wks,(/plot1,plot2/),(/1,2/),pres)

end

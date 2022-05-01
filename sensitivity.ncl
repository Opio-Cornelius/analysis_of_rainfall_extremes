; Script for SENSITIVITY (mathematical difference between two wrf ouput files)

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

  a = addfile("/home/opio/Build_WRF/result/low_res/lin/wrfout_d03_2015-05-25_00:00:00.nc","r")
  b = addfile("/home/opio/Build_WRF/result/low_res/cam/wrfout_d03_2015-05-25_00:00:00.nc","r")
 
 c1 = a->RAINNC(80,:,:)
 d1 = b->RAINNC(80,:,:)

 c2 = a->RAINC(80,:,:)
 d2 = b->RAINC(80,:,:)

 c = c1 + c2
 d = d1 + d2

  diff = d - c
  printVarSummary(diff)
  diff@description = "Sensitivity"

  wks = gsn_open_wks("pdf","precip_diff2_23")
  gsn_define_colormap(wks,"gui_default")


; Set some basic resources
  res = True
  res@MainTitle                   = "REAL-TIME WRF"

  pltres = True
  mpres = True
  mpres@mpGeophysicalLineColor = "Black"
  mpres@mpNationalLineColor    = "Black"
  mpres@mpUSStateLineColor     = "Black"
  mpres@mpGridLineColor        = "transparent"
  mpres@mpLimbLineColor        = "Black"
  mpres@mpPerimLineColor       = "Black"
  mpres@mpOutlineBoundarySets  = "AllBoundaries"
  mpres@mpGeophysicalLineThicknessF = 7.0
  mpres@mpNationalLineThicknessF = 7.0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; First get the variables we will need        

    slp = wrf_user_getvar(a,"slp",-1)    ; slp
      wrf_smooth_2d( slp, 3 )            ; smooth slp

  ; Get non-convective, convective 
  ; Calculate total precipitation
    rain_exp = wrf_user_getvar(a,"RAINNC",80)
    rain_con = wrf_user_getvar(a,"RAINC",80)
    rain_tot = rain_exp + rain_con
      rain_tot@description = "Total Precipitation"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; What times and how many time steps are in the data set?
  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  do it = 2,ntimes,2             ; TIME LOOP - start at hour 6 as we are only interested in 6hourly tendencies

    print("Working on time: " + times(it) )
    res@TimeLabel = times(it)   ; Set Valid time to use on plots

 
   ; Plotting options for Precipitation
     opts_r = res                        
   ; opts_r@UnitLabel            = "mm"
     opts_r@cnLevelSelectionMode = "ExplicitLevels"
     opts_r@cnLevels             = (/ -102.4, -51.2, -25.6, -12.8, \
                                     -6.4, -3.2, -1.6, -0.8, -0.4, -0.2, -0.1, 0, \ 
                                     0.1, 0.2, 0.4, 0.8, 1.6, 3.2, 6.4, \
                                     12.8, 25.6, 51.2, 102.4/)
   
     opts_r@cnFillPalette = "circular_2"
     opts_r@cnInfoLabelOn        = False
     opts_r@cnConstFLabelOn      = False
     opts_r@cnFillOn             = True
  

   ; Total Precipitation (color fill)
     contour_tot = wrf_contour(a,wks,diff, opts_r)                
   

     ; MAKE PLOTS                                       

     ; Total Precipitation 
       plot = wrf_map_overlays(a,wks,contour_tot,pltres,mpres)



  end do        ; END OF TIME LOOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end

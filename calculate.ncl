; Script for calculating and plotting difference

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl" 

begin

;---Read the source and destination lat/lon grids
 
    srcFileName = "wrf.nc" 
    dstFileName = "precip.nc" 
    sfile = addfile(srcFileName,"r") 
    dfile = addfile(dstFileName,"r") 
    src_lat = sfile->XLAT(40,:,:) 
    src_lon = sfile->XLONG(40,:,:) 

    wrf_times = wrf_user_list_times(sfile)         ; "2008-09-29_18:30:00", etc

    dst_lat = dfile->lat 
    dst_lon = dfile->lon 

;---Read the data you want to regrid 
    r1 = sfile->RAINNC
    r2 = sfile->RAINC
    rain = r1 + r2
    rain@long_name = "Total Rain"            
    rain@units = r1@units
    copy_VarCoords(r1, rain)

;---Options for regridding 
    Opt = True 

;---source grid information 
    Opt@SrcRegional = True 
    Opt@SrcGridLat = src_lat 
    Opt@SrcGridLon = src_lon 

;---destination grid information 
    Opt@DstRegional = True 
    Opt@DstGridLat = dst_lat 
    Opt@DstGridLon = dst_lon 
 
    Opt@ForceOverwrite = True 
    Opt@CopyVarCoords = True ; Whether to copy coordinate information 
                                 ; to regridded variable 
    Opt@InterpMethod   = "conserve"   ; use "conserve" for precipitation

; ---- Regrid 
   var_regrid = ESMF_regrid(rain,Opt) ; Regrid "var" to new grid 

;   printVarSummary(var_regrid)
;   printMinMax(rain,0)
;   printMinMax(var_regrid,0)

   rain@lat2d = src_lat
   rain@lon2d = src_lon

;------ Calculate before displaying

  gpm_rain = dfile->GPM_3IMERGDF_04_precipitationCal

  diff = var_regrid(40,:,:) - gpm_rain
  printVarSummary(diff)
  diff@long_name = "Difference Variable"            
  copy_VarCoords(gpm_rain, diff)


; ---- Plotting

   wks = gsn_open_wks("png","difference")

   res                       = True

   res@gsnMaximize           = True

   res@cnFillOn              = True
   res@cnLinesOn             = False
   res@cnLineLabelsOn        = False

 ;  res@lbLabelBarOn          = False    ; Turn on later in panel

   res@mpMinLatF             = min(dst_lat)
   res@mpMaxLatF             = max(dst_lat)
   res@mpMinLonF             = min(dst_lon)
   res@mpMaxLonF             = max(dst_lon)
   res@mpDataBaseVersion     = "MediumRes"
   res@pmTickMarkDisplayMode = "Always"

;--- Regional data, don't add longitude cyclic point
   res@gsnAddCyclic  = False

;---Title stuff
   res@tiMainFont     = "helvetica"
   res@pmTitleZone    = 4
   res@gsnRightString = ""
   res@gsnLeftString  = ""

   plot_diff = gsn_csm_contour_map(wks,diff(:,:),res)

end

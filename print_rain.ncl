; Script for extracting rainfall data

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

  a  = addfile("/home/opio/Build_WRF/result/low_res/lin/wrfout_d03_2015-05-25_00:00:00","r")


times = wrf_user_list_times(a)            ; get times in the file 
ntimes = dimsizes(times)            ; number of times in the file 
wind_speed = new(ntimes,float)            ; creation of a windspeed vector at each time step
;print(ntimes)

do it = 0,ntimes-1                  ;Loop for the time: it= starting time
print("Working on time " + it )
time = it



; **** Select lon & lat of the point of interest *****


 res = True      
 res@returnInt = True               ; False : return real values, True: return interger values
 lat = 0.333                  ; Latitude of the point of interest
 lon = 32.578                 ; Longitude of the point of interest
 point = wrf_user_ll_to_ij(a,lon,lat,res) 
 
 x = point(1)
 y = point(0)

 print("X location is: " + x)            ; print the value of X at the screen
 print("Y location is: " + y)            ; print the value of Y at the screen



;  ***** extract rainfall data ******


  r1 = wrf_user_getvar(a, "RAINC", time)
  r2 = wrf_user_getvar(a, "RAINNC", time)

  rain = r1 + r2

  print(rain(x,y))


 end do

end

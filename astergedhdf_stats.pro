pro astergedhdf_stats

; Open file
folderpath = 'D:/03 Emissivity/01 Standard Diviation/ASTER GED/' ;The local address
cd, folderpath ; change directory
; Create a log file
logfname= folderpath + 'stat_log_file.yaml' 
OPENW,1,logfname 
HDF_files = FILE_SEARCH ('*.h5')
len= size(HDF_files, /DIMENSIONS)

for file_idx= 0, len[0]-1, 1 do begin
  file_name = HDF_files[file_idx] ; File name
  file_id=H5F_OPEN(file_name) ; Open HDF5 file
  ; Read Emissivity Mean or STD subdatasets.
  field_name = '/Emissivity/Mean'
  ;field_name = '/Emissivity/SDev'
  data_id=H5D_OPEN(file_id,field_name)
  data=H5D_READ(data_id)
  for bi = 0, 4 do begin
    band = data(*,*,bi) ; ; select band idx
    printf, 1, 'file:', file_name,' band:', bi+10
    IMAGE_STATISTICS, band, COUNT = pixelNumber, $
      MAXIMUM = pixelMax, $
      MEAN = pixelMean, MINIMUM = pixelMin, $
      STDDEV = pixelDeviation
      printf, 1, 'Band STATISTICS:'
      printf, 1, 'Total Number of Pixels = ', pixelNumber
      printf, 1, 'Maximum Pixel Value = ', pixelMax
      printf, 1, 'Mean of Pixel Values = ', pixelMean
      printf, 1, 'Minimum Pixel Value = ', pixelMin
      printf, 1, 'Standard Deviation of Pixel Values = ', pixelDeviation
      
      k = size(band)
      a = 0.0
      b = 0.0
      c = 0.0
      d = 0.0
      e = 0.0

      for i = 0, k(2)-1 do begin
        for j = 0, k(2)-1 do begin
          if (band[i,j] eq -9999) then a = a+1.0 else $
            if(band[i,j] gt -9999 and band[i,j] lt 0) then b = b+1.0 else $
            if (band[i,j] ge 0 and band[i,j] le 1000) then c = c+1.0 else $
            if (band[i,j] gt 1000 and band[i,j] le 10000) then d = d+1.0 else $
            if (band[i,j] gt 10000) then e = e+1.0
        endfor
      endfor


      printf, 1, 'percentage NoData ', 100*(a/1000000.0)
      printf, 1, 'percentage < 0 ', 100*(b/1000000.0)
      printf, 1, 'percentage [0-1000]', 100*(c/1000000.0)
      printf, 1, 'percentage [1000-10000]', 100*(d/1000000.0)
      printf, 1, 'percentage >10000 ', 100*(e/1000000.0)
      
  endfor
  H5D_CLOSE, data_id ; close dataset.
endfor

close, 1


 end
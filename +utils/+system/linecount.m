function n = linecount(filename, doError)

if nargin < 2 || isempty(doError)
    doError = true;
end

if (~ispc) 
  [status, cmdout]= system(['wc -l ',filename]);
  if(status~=1)
      scanCell = textscan(cmdout,'%u %s');
      n = double(scanCell{1}); 
  else
      if doError
          error(cmdout)
      end
      n = -1;
  end
else
  error('Function not available for windows.. using unix commands');
end
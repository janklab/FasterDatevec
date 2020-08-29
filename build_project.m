function build_project

  function say(fmt, varargin)
    msg = sprintf(fmt, varargin{:});
    fprintf('%s - %s\n', datestr(now, 'HH:MM:SS'), msg);
  end

  dMexC = dir('Mcode/**/*.c');
  dMexCpp = dir('Mcode/**/*.cpp');
  dAllMex = [dMexC; dMexCpp];
  mexFileSources = fullfile({dAllMex.folder}, {dAllMex.name});
  mexFileSources = string(mexFileSources(:));
  
  nMex = numel(mexFileSources);
  for i = 1:nMex
    mexSourceFile = mexFileSources(i);
    say('Building MEX file %d/%d: %s', i, nMex, mexSourceFile);
    mex('-R2018a', mexSourceFile, '-outdir', fileparts(mexSourceFile), '-silent');
  end

end
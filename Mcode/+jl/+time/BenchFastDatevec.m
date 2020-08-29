classdef BenchFastDatevec
  % Benchmark for fastdatevec
  
  %#ok<*NBRAK>
  
  properties
    % Bench cases as {name, dates; ...}
    cases = {
      'one day'       datenum(1966, 6, 14)
      'one date'      datenum(1966, 6, 14, 12, 34, 56)
      '100 days'      datenum(1966, 6, 14) + [0:99]
      '100 dates'     datenum(1966, 6, 14, 12, 34, 56) + [0:99]
      '1000 days'     datenum(1966, 6, 14) + [0:999]
      '1000 dates'    datenum(1966, 6, 14, 12, 34, 56) + [0:999]
      } 
    % How many times to run each case
    numIters = 1000
  end
  
  methods
    
    function out = bench(this)
      % Run the benchmark
      nCases = size(this.cases, 1);
      etimes = NaN(nCases, 2);
      usecs = NaN(nCases, 2); % usec per element
      for iCase = 1:nCases
        [descr,datenums] = this.cases{iCase,:};
        nIters = this.numIters;
        nEls = numel(datenums);
        fprintf('Benching %s...\n', descr);
        t0_datevec = tic;
        for iIter = 1:nIters
          [~] = datevec(datenums);
        end
        te_datevec = toc(t0_datevec);
        t0 = tic;
        for iIter = 1:nIters
          [~] = fastdatevec(datenums);
        end
        te_fastdatevec = toc(t0);
        etimes(iCase,:) = round([te_datevec te_fastdatevec], 6);
        usecs(iCase,:) = round(etimes(iCase,:) * 1000000 / nEls);
      end
      tbl1 = array2table(etimes, 'VariableNames',{'datevec','fastdatevec'});
      tbl2 = array2table(usecs, 'VariableNames',{'datevec','fastdatevec'});
      out = table(string(this.cases(:,1)), tbl1, tbl2, ...
        'VariableNames',{'Case','Time (s)','usec per elem'});
    end
    
  end
  
end
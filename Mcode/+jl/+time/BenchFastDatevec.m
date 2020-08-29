classdef BenchFastDatevec
  % Benchmark for fastdatevec
  
  %#ok<*NBRAK>
  
  properties
    % Bench cases as {name, dates; ...}
    % Only go 30,000 days out to stay before 2050
    cases = {
      'one day'         datenum(1966, 6, 14)
      'one date'        datenum(1966, 6, 14, 12, 34, 56)
      '100 days'        datenum(1966, 6, 14) + [0:99]
      '100 dates'       datenum(1966, 6, 14, 12, 34, 56) + [0:99]
      '1000 days'       datenum(1966, 6, 14) + [0:999]
      '1000 dates'      datenum(1966, 6, 14, 12, 34, 56) + [0:999]
      '10000 days'      datenum(1966, 6, 14) + [0:9999]
      '10000 dates'     datenum(1966, 6, 14, 12, 34, 56) + [0:9999]
      '100000 days'     datenum(1966, 6, 14) + rem([0:99999], 30000)
      '100000 dates'    datenum(1966, 6, 14, 12, 34, 56) + rem([0:99999], 30000)
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
          [~] = jl.time.fastdatevecm(datenums);
        end
        te_fastdatevecm = toc(t0);
        caseEtimes = [te_datevec te_fastdatevecm];
        etimes(iCase,:) = round(caseEtimes, 3);
        usecs(iCase,:) = round(caseEtimes * 1000000 / nEls);
      end
      tbl1 = array2table(etimes, 'VariableNames',{'datevec','fastdatevecm'});
      tbl2 = array2table(usecs, 'VariableNames',{'datevec','fastdatevecm'});
      out = table(string(this.cases(:,1)), tbl1, tbl2, ...
        'VariableNames',{'Case','Time (s)','usec per elem'});
    end
    
  end
  
end
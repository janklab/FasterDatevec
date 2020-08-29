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
      %'100000 days'     datenum(1966, 6, 14) + rem([0:99999], 30000)
      %'100000 dates'    datenum(1966, 6, 14, 12, 34, 56) + rem([0:99999], 30000)
      } 
    % How many times to run each case
    numIters (1,1) double = 1000
    % Whether to do the underlying implementation variations
    doImpls (1,1) logical = false
  end
  
  methods
    
    function out = bench(this)
      % Run the benchmark
      nCases = size(this.cases, 1);
      etimes = NaN(nCases, 2);
      caseNumels = NaN(nCases, 1);
      funcNames = ["datevec", "fastdatevec"];
      if this.doImpls
        funcNames = [funcNames "fastdvecm" "fastdvecmx"];
      end
      for iCase = 1:nCases
        [descr,datenums] = this.cases{iCase,:};
        nIters = this.numIters;
        caseNumels(iCase) = numel(datenums);
        fprintf('Benching %s...\n', descr);
        t0 = tic;
        for iIter = 1:nIters
          [~] = datevec(datenums);
        end
        te_datevec = toc(t0);
        etimes(iCase,1) = te_datevec;
        t0 = tic;
        for iIter = 1:nIters
          [~] = fastdatevec(datenums);
        end
        te_fastdatevec = toc(t0);
        etimes(iCase,2) = te_fastdatevec;
        if this.doImpls
          t0 = tic;
          for iIter = 1:nIters
            [~] = jl.time.internal.fastdatevecm(datenums);
          end
          te_fastdatevecm = toc(t0);
          etimes(iCase,3) = te_fastdatevecm;
          t0 = tic;
          for iIter = 1:nIters
            [~] = jl.time.internal.fastdatevecmx(datenums);
          end
          te_fastdatevecmx = toc(t0);
          etimes(iCase,4) = te_fastdatevecmx;
        end
      end
      out = jl.time.BenchFastDatevecResult(this.cases(:,1), ...
        caseNumels, etimes, funcNames);
    end
    
  end
  
end
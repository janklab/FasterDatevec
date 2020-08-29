classdef BenchFastDatevec
  % Benchmark for fastdatevec
  %
  % Examples:
  %
  % b = jl.time.BenchFastDatevec;
  % rslt = b.bench
  %
  % % Bench all implementation alternatives, including the currently-very-slow
  % % C++ MEX one.
  % b = jl.time.BenchFastDatevec;
  % b.doImpls = true;
  % b.maxCaseNumel = 20000;
  % rslt = b.bench
  
  %#ok<*NBRAK>
  %#ok<*PROP>
  
  properties
    % Bench cases as {name, dates; ...}
    % About the rem: only go 30,000 days out to stay before 2050
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
    numIters (1,1) double = 1000
    % Whether to do the underlying implementation variations
    doImpls (1,1) logical = false
    % Max size of cases to run. Dial this down to 10000ish if you're enabling 
    % the impls.
    maxCaseNumel (1,1) double = Inf
  end
  
  methods
    
    function out = bench(this)
      % Run the benchmark
      caseNumels = cellfun(@numel, this.cases(:,2));
      tfToDo = caseNumels <= this.maxCaseNumel;
      cases = this.cases(tfToDo,:);
      caseNumels = caseNumels(tfToDo);
      nCases = size(cases, 1);
      etimes = NaN(nCases, 2);
      funcNames = ["datevec" "fastdatevec"];
      if this.doImpls
        funcNames = [funcNames "fastdvecm" "fastdvecmx" "fastdvecmxcpp"];
      end
      for iCase = 1:nCases
        [descr,datenums] = cases{iCase,:};
        nIters = this.numIters;
        caseNumels(iCase) = numel(datenums);
        fprintf('Benching %s...\n', descr);
        t0 = tic;
        for iIter = 1:nIters
          [~] = datevec(datenums);
        end
        etimes(iCase,1) = toc(t0);
        t0 = tic;
        for iIter = 1:nIters
          [~] = fastdatevec(datenums);
        end
        etimes(iCase,2) = toc(t0);
        if this.doImpls
          t0 = tic;
          for iIter = 1:nIters
            [~] = jl.time.internal.fastdatevecm(datenums);
          end
          etimes(iCase,3) = toc(t0);
          t0 = tic;
          for iIter = 1:nIters
            [~] = jl.time.internal.fastdatevecmex(datenums);
          end
          etimes(iCase,4) = toc(t0);
          t0 = tic;
          for iIter = 1:nIters
            [~] = jl.time.internal.fastdatevecmex(datenums, true);
          end
          etimes(iCase,5) = toc(t0);
        end
      end
      out = jl.time.BenchFastDatevecResult(cases(:,1), ...
        caseNumels, etimes, funcNames);
    end
    
  end
  
end
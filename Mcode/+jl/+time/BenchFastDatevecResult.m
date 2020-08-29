classdef BenchFastDatevecResult
  
  properties
    caseNames string
    caseNumels double
    caseEtimes double
    funcNames string
    caseUsecPerEl double
  end
  
  methods
    
    function this = BenchFastDatevecResult(caseNames, caseNumels, ...
        caseEtimes, funcNames)
      this.caseNames = caseNames;
      this.caseNumels = caseNumels;
      this.caseEtimes = caseEtimes;
      this.funcNames = funcNames;
      this = this.computeDerivedValues;
    end
    
    function this = computeDerivedValues(this)
      this.caseUsecPerEl = round(this.caseEtimes * 1000000 ./ this.caseNumels);
    end
    
    function disp(this)
      disp(this.toTable);
    end
    
    function out = toTable(this)
      roundEtimes = round(this.caseEtimes, 3);
      tbl1 = array2table(roundEtimes, 'VariableNames',this.funcNames);
      tbl2 = array2table(this.caseUsecPerEl, 'VariableNames',this.funcNames);
      out = table(this.caseNames, tbl1, tbl2, ...
        'VariableNames', {'Case','Time (s)','usec per elem'});
      out.SpeedRatio = round(this.caseEtimes(:,1) ./ this.caseEtimes(:,2), 1);
    end
    
  end
  
end
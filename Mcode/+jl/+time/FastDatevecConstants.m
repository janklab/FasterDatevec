classdef FastDatevecConstants
  
  properties (Constant)
    instance = jl.time.FastDatevecConstants
  end
  
  properties
    FirstPrecalcYear
    LastPrecalcYear
    FirstPrecalcDay
    LastPrecalcDay
    DayAfterLastPrecalcDay
    DatenumDays
    Year
    Month
    Day
    DayDvecPart
  end
  
  methods
    
    function this = FastDatevecConstants()
      today = fix(now);
      todayDvec = datevec(today);
      thisYear = todayDvec(1);
      this.FirstPrecalcYear = 1966; % Always go back far enough to include Flag Day
      this.LastPrecalcYear = thisYear + 50;
      this.FirstPrecalcDay = datenum(this.FirstPrecalcYear, 1, 1);
      this.LastPrecalcDay = datenum(this.LastPrecalcYear, 12, 31);
      this.DayAfterLastPrecalcDay = this.LastPrecalcDay + 1;
      dnums = this.FirstPrecalcDay:this.LastPrecalcDay;
      this.DatenumDays = dnums;
      dvec = datevec(dnums);
      this.Year = dvec(:,1);
      this.Month = dvec(:,2);
      this.Day = dvec(:,3);
      this.DayDvecPart = dvec(:,1:3);
    end
    
  end
  
end
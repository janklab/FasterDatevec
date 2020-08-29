classdef FastDatevecConstants
  
  properties (Constant)
    instance = jl.time.internal.FastDatevecConstants
  end
  
  properties
    FirstPrecalcYear
    LastPrecalcYear
    FirstPrecalcDatenum
    LastPrecalcDatenum
    DayAfterLastPrecalcDatenum
    DatenumDays
    DatenumDaysInt32
    Year
    Month
    Day
    DayDvecPart
    % This format will be more CPU cache friendly
    DayDvecPartTranspose
    DayDvecPartTransposeUint16
    % For convenient passing to MEX functions
    ConstantsInCells
  end
  
  methods
    
    function this = FastDatevecConstants()
      today = fix(now);
      todayDvec = datevec(today);
      thisYear = todayDvec(1);
      this.FirstPrecalcYear = 1966; % Always go back far enough to include Flag Day
      this.LastPrecalcYear = thisYear + 50;
      this.FirstPrecalcDatenum = datenum(this.FirstPrecalcYear, 1, 1);
      this.LastPrecalcDatenum = datenum(this.LastPrecalcYear, 12, 31);
      this.DayAfterLastPrecalcDatenum = this.LastPrecalcDatenum + 1;
      dnums = this.FirstPrecalcDatenum:this.LastPrecalcDatenum;
      this.DatenumDays = dnums;
      this.DatenumDaysInt32 = int32(this.DatenumDays);
      dvec = datevec(dnums);
      this.Year = dvec(:,1);
      this.Month = dvec(:,2);
      this.Day = dvec(:,3);
      this.DayDvecPart = dvec(:,1:3);
      this.DayDvecPartTranspose = this.DayDvecPart';
      this.DayDvecPartTransposeUint16 = uint16(this.DayDvecPartTranspose);
      this.ConstantsInCells = {
        this.FirstPrecalcYear
        this.LastPrecalcYear
        this.FirstPrecalcDatenum
        this.LastPrecalcDatenum
        this.DatenumDays
        this.DatenumDaysInt32
        this.Year
        this.Month
        this.Day
        this.DayDvecPartTranspose
        this.DayDvecPartTransposeUint16
        };
    end
    
  end
  
end
function out = fastdatevecmex(datenums, useCpp)
% Wrapper for MEX-based implementation of fastdatevec
if nargin < 2; useCpp = false; end

%#ok<*PUSE>

persistent FirstPrecalcYear LastPrecalcYear FirstPrecalcDatenum LastPrecalcDatenum
persistent DayAfterLastPrecalcDatenum 
persistent PrecalcDatenumDays PrecalcYear PrecalcMonth PrecalcDay PrecalcDayDvecPart
persistent ConstantsInCells
if isempty(FirstPrecalcYear)
  constants = jl.time.internal.FastDatevecConstants.instance;
  FirstPrecalcYear = constants.FirstPrecalcYear;
  LastPrecalcYear = constants.LastPrecalcYear;
  FirstPrecalcDatenum = constants.FirstPrecalcDatenum;
  LastPrecalcDatenum = constants.LastPrecalcDatenum;
  DayAfterLastPrecalcDatenum = constants.DayAfterLastPrecalcDatenum;
  PrecalcDatenumDays = constants.DatenumDays;
  PrecalcYear = constants.Year;
  PrecalcMonth = constants.Month;
  PrecalcDay = constants.Day;
  PrecalcDayDvecPart = constants.DayDvecPart;
  ConstantsInCells = constants.ConstantsInCells;
end

dnums = datenums;
tfPrecalc = dnums >= FirstPrecalcDatenum & dnums < DayAfterLastPrecalcDatenum;
if any(tfPrecalc)
  isAllPrecalc = all(tfPrecalc);
  if isAllPrecalc
    dnumsPrecalc = dnums;
    %dnumsNotPrecalc = [];
    %dvecNotPrecalc = NaN(0,6);
  else
    dnumsPrecalc = dnums(tfPrecalc);
    dnumsNotPrecalc = dnums(~tfPrecalc);
    dvecNotPrecalc = datevec(dnumsNotPrecalc);
  end
  
  if useCpp
    datepartsFromMex = jl.time.internal.fastdateparts_precalc_mexcpp(dnumsPrecalc, ...
      ConstantsInCells);
  else
    datepartsFromMex = jl.time.internal.fastdateparts_precalc_mex(dnumsPrecalc, ...
      ConstantsInCells);
  end
  dp = datepartsFromMex;
  dvecPrecalc = [double(dp{1}) double(dp{2}) double(dp{3}) double(dp{4}) ...
    double(dp{5}) dp{6}];
  
  if isAllPrecalc
    dvec = dvecPrecalc;
  else
    dvec = NaN(numel(dnums), 6);
    dvec(tfPrecalc,:) = dvecPrecalc;
    dvec(~tfPrecalc,:) = dvecNotPrecalc;
  end
  out = dvec;
else
  out = datevec(datenums);
end
end
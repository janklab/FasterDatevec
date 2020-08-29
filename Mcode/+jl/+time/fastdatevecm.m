function out = fastdatevecm(datenums)
% Pure M-code implementation of fastdatevec

persistent FirstPrecalcYear LastPrecalcYear FirstPrecalcDay LastPrecalcDay
persistent DayAfterLastPrecalcDay 
persistent PrecalcDatenumDays PrecalcYear PrecalcMonth PrecalcDay PrecalcDayDvecPart
if isempty(FirstPrecalcYear)
  constants = jl.time.FastDatevecConstants.instance;
  FirstPrecalcYear = constants.FirstPrecalcYear;
  LastPrecalcYear = constants.LastPrecalcYear;
  FirstPrecalcDay = constants.FirstPrecalcDay;
  LastPrecalcDay = constants.LastPrecalcDay;
  DayAfterLastPrecalcDay = constants.DayAfterLastPrecalcDay;
  PrecalcDatenumDays = constants.DatenumDays;
  PrecalcYear = constants.Year;
  PrecalcMonth = constants.Month;
  PrecalcDay = constants.Day;
  PrecalcDayDvecPart = constants.DayDvecPart;
end

dnums = datenums;
tfPrecalc = dnums >= FirstPrecalcDay & dnums < DayAfterLastPrecalcDay;
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
  
  nPrecalc = numel(dnumsPrecalc);
  datePart = fix(dnumsPrecalc);
  timePart = rem(dnumsPrecalc, 1);
  
  [tf,loc] = ismember(datePart, PrecalcDatenumDays);
  if ~all(tf)
    error('Oops! Missing expected precalced datenums');
  end
  %year = PrecalcYear(loc);
  %month = PrecalcMonth(loc);
  %day = PrecalcDay(loc);
  ymd = PrecalcDayDvecPart(loc,:);
  
  tfMidnight = timePart == 0;
  if all(tfMidnight)
    hms = zeros(nPrecalc, 3);
  else
    secondsOfDayWithFrac = timePart * (24 * 60 * 60);
    secondsOfDayWithFrac = secondsOfDayWithFrac(:);
    fractionalSeconds = rem(secondsOfDayWithFrac, 1);
    secondsOfDay = uint32(secondsOfDayWithFrac);
    hour = double(secondsOfDay / (60 * 60));
    secondsOfHour = rem(secondsOfDay, 60 * 60);
    minute = double(secondsOfHour / 60);
    second = double(rem(secondsOfHour, 60));
    seconds = second + fractionalSeconds;
    hms = [hour minute seconds];
  end
  
  dvecPrecalc = [ymd hms];
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
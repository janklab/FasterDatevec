function out = fastdatevecm(datenums)
% A pure M-code implementation of fastdatevec

%#ok<*PUSE>

persistent FirstPrecalcYear LastPrecalcYear FirstPrecalcDay LastPrecalcDay
persistent DayAfterLastPrecalcDay 
persistent PrecalcDatenumDays PrecalcYear PrecalcMonth PrecalcDay PrecalcDayDvecPart
if isempty(FirstPrecalcYear)
  constants = jl.time.internal.FastDatevecConstants.instance;
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
  timePart = dnumsPrecalc - datePart;
  
  datenumIndex = datePart - FirstPrecalcDay + 1;
  loc = datenumIndex;
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
    secondsOfDay = fix(secondsOfDayWithFrac);
    fractionalSeconds = secondsOfDayWithFrac - secondsOfDay;
    secondsOfDay = uint32(secondsOfDayWithFrac);
    hourOfDay = secondsOfDay / (60 * 60);
    hour = double(hourOfDay);
    secondsOfHour = secondsOfDay - (hourOfDay * 60 * 60);
    minuteOfHour = secondsOfHour / 60;
    minute = double(minuteOfHour);
    secondsOfMinute = secondsOfHour - (minuteOfHour * 60);
    second = double(secondsOfMinute);
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
function out = fastdatevecm(datenums)
% A pure M-code implementation of fastdatevec

%#ok<*PUSE>

persistent FirstPrecalcYear LastPrecalcYear FirstPrecalcDatenum LastPrecalcDatenum
persistent DayAfterLastPrecalcDatenum 
persistent PrecalcDatenumDays PrecalcYear PrecalcMonth PrecalcDay PrecalcDayDvecPart
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
  
  nPrecalc = numel(dnumsPrecalc);
  datePart = fix(dnumsPrecalc);
  timePart = dnumsPrecalc - datePart;
  
  datenumIndex = datePart - FirstPrecalcDatenum + 1;
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
function out = fastdatevec(datenums, outformat)
% A faster version of datevec
if nargin < 2; outformat = "double"; end
if isa(datenums, 'datetime')
  % TODO: Figure out how to handle time zones
  if ~isempty(datenums.TimeZone)
    error('datetimes with TimeZones are not supported (yet).');
  end
  datenums = datenum(datenums);
end

out = jl.time.fastdatevecm(datenums);

end

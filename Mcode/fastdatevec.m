function out = fastdatevec(datenums)
% A faster version of datevec
%if nargin < 2; outformat = "double"; end

% Turn this short-circuit on once development is done
%optimizationThreshold = 1000;
%if numel(datenums) < optimizationThreshold
%  out = datevec(datenums);
%  return
%end

if isa(datenums, 'datetime')
  % TODO: Figure out how to handle time zones
  if ~isempty(datenums.TimeZone)
    error('datetimes with TimeZones are not supported (yet).');
  end
  datenums = datenum(datenums);
end

%out = jl.time.internal.fastdatevecm(datenums);
out = jl.time.internal.fastdatevecmex(datenums);
end

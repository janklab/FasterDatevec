# FasterDatevec

An optimized version of datevec for Matlab.

FasterDatevec is part of the [Janklab suite of libraries for Matlab](https://github.com/janklab).

## Caution: Experimental Code

| WARNING: This is pre-alpha-quality, experimental code. Do not use it for anything yet! |
| ----- |

## Overview

FasterDatevec is an attempt to provide an optimized version of Matlab's `datevec()` function which will run faster for common use cases (that is, dates in the range of about 1950-2050).

The optimized datevec function is called `fastdatevec()`. It has the exact same interface as `datevec()`, and can be used as a drop-in replacement for it.

## Installation and Use

Download the FasterDatevec distribution, either by cloning the [repo](https://github.com/janklab/FasterDatevec) or downloading a release distribution from its [Releases page](https://github.com/janklab/FasterDatevec/releases).

Then get its `Mcode/` directory on your Matlab path. No other setup is necessary. At that point, you can call `fastdatevec()`.

To see examples of how it's used, or to test its performance on your system, use the `jl.time.BenchFastDatevec` tool.

### Examples

```matlab
% Convert datenums to datevecs

dnum = now;
dvec = fastdatevec(dnum)

dnums = now + 0:.3:2;
dvec = fastdatevec(dnums)

% Benchmark fastdatevec

b = jl.time.BenchFastDatevec;
rslt = b.bench
```

## Author

FasterDatevec is written by [Andrew Janke](https://apjanke.net).

The project home page is <https://github.com/janklab/FasterDatevec>. Bug reports and feature requests are welcome there.

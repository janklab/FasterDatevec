#include "mex.h"
#include "matrix.h"
#include <stdio.h>
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{

  // DEBUG
  mxArray *dummyOut = mxCreateString("Hello, world!");
  plhs[0] = dummyOut;
  return;
  
  // Inputs

  if (nrhs != 2) {
    mexErrMsgIdAndTxt("jl:time:InvalidInput", "Exactly 2 inputs are required.");
  }
  const mxArray *mxInDatenums = prhs[0];
  if (!mxIsDouble(mxInDatenums)) {
    mexErrMsgIdAndTxt("jl:time:InvalidInput", "Input 1 must be a double (of datenums).");
  }
  double *inDatenums = mxGetDoubles(mxInDatenums);
  const mxArray *mxConstants = prhs[1];
  if (!mxIsCell(mxConstants)) {
    mexErrMsgIdAndTxt("jl:time:InvalidInput", "Input 2 must be a cell.");
  }
  const mxArray *mxFirstPrecalcYear = mxGetCell(mxConstants, 0);
  const mxArray *mxFirstPrecalcDatenum = mxGetCell(mxConstants, 2);
  const mxArray *mxPrecalcDayDatenums = mxGetCell(mxConstants, 5);
  const mxArray *mxPrecalcDateparts = mxGetCell(mxConstants, 10);
  double firstPrecalcYear = mxGetScalar(mxFirstPrecalcYear);
  double firstPrecalcDatenum = mxGetScalar(mxFirstPrecalcDatenum);
  int32_t firstPrecalcDaypart = (int32_t) firstPrecalcDatenum;
  int32_t *precalcDayDatenums = mxGetInt32s(mxPrecalcDayDatenums);
  uint16_t *precalcDateparts = mxGetUint16s(mxPrecalcDateparts);
  uint16_t *precalc = precalcDateparts;

  mwSize n = mxGetNumberOfElements(mxInDatenums);

  // DEBUG
  mxArray *mxOut1 = mxCreateCellMatrix(6, 1);
  plhs[0] = mxOut1;
  return;

  // Outputs

  mxArray *mxOutYear = mxCreateNumericMatrix(n, 1, mxINT16_CLASS, mxREAL);
  mxArray *mxOutMonth = mxCreateNumericMatrix(n, 1, mxUINT8_CLASS, mxREAL);
  mxArray *mxOutDay = mxCreateNumericMatrix(n, 1, mxUINT8_CLASS, mxREAL);
  mxArray *mxOutHour = mxCreateNumericMatrix(n, 1, mxUINT8_CLASS, mxREAL);
  mxArray *mxOutMinute = mxCreateNumericMatrix(n, 1, mxUINT8_CLASS, mxREAL);
  mxArray *mxOutSeconds = mxCreateNumericMatrix(n, 1, mxDOUBLE_CLASS, mxREAL);
  int16_t *year = mxGetInt16s(mxOutYear);
  uint8_t *month = mxGetUint8s(mxOutMonth);
  uint8_t *day = mxGetUint8s(mxOutDay);
  uint8_t *hour = mxGetUint8s(mxOutHour);
  uint8_t *minute = mxGetUint8s(mxOutMinute);
  double *seconds = mxGetDoubles(mxOutSeconds);

  // Logic

  int16_t tmpYear;
  uint8_t tmpMonth;
  uint8_t tmpDay;
  uint8_t tmpHour;
  uint8_t tmpMinute;
  double tmpSecond;
  double secondsOfDayWithFrac;
  double secondsOfDayDouble;
  double fractionalSeconds;
  uint32_t secondsOfDay;
  uint8_t hourOfDay;
  uint32_t secondsOfHour;
  uint8_t minuteOfHour;
  uint32_t secondsOfMinute;
  double secondsWithFrac;

  for (size_t i = 0; i < n; i++) {
      double dnum = inDatenums[i];

      // debugging
      continue;

      // Special condition handling
      // TODO

      double dayPartDouble = floor(dnum);
      double timePart = dnum - dayPartDouble;
      int32_t dayPart = (int32_t) dayPartDouble;
      
      // Day part

      size_t ixPrecalc = dayPart - firstPrecalcDaypart;
      tmpYear = *(precalc + ixPrecalc*3 + 0);
      tmpMonth = *(precalc + ixPrecalc*3 + 1);
      tmpDay = *(precalc + ixPrecalc*3 + 2);
      //tmpYear = precalc[ixPrecalc][0];
      //tmpMonth = precalc[ixPrecalc][1];
      //tmpDay = precalc[ixPrecalc][2];
      year[i] = tmpYear;
      month[i] = tmpMonth;
      day[i] = tmpDay;

      // Time part

      if (timePart == 0.0) {
        hour[i] = 0;
        minute[i] = 0;
        seconds[i] = 0.0;
        continue;
      }

      secondsOfDayWithFrac = timePart * (24 * 60 * 60);
      secondsOfDayDouble = floor(secondsOfDayWithFrac);
      fractionalSeconds = secondsOfDayWithFrac - secondsOfDayDouble;
      secondsOfDay = (uint32_t) secondsOfDayDouble;
      hourOfDay = secondsOfDay / (60 * 60);
      secondsOfHour = secondsOfDay - (hourOfDay * 60 * 60);
      minuteOfHour = secondsOfHour / 60;
      secondsOfMinute = secondsOfHour - (minuteOfHour * 60);
      secondsWithFrac = ((double) secondsOfMinute) + fractionalSeconds;
      hour[i] = hourOfDay;
      minute[i] = minuteOfHour;
      seconds[i] = secondsWithFrac;
  }

  // Package return values

  /*
  mxArray *mxOut1 = mxCreateCellMatrix(6, 1);
  mxSetCell(mxOut1, 0, mxOutYear);
  mxSetCell(mxOut1, 1, mxOutMonth);
  mxSetCell(mxOut1, 2, mxOutDay);
  mxSetCell(mxOut1, 3, mxOutHour);
  mxSetCell(mxOut1, 4, mxOutMinute);
  mxSetCell(mxOut1, 5, mxOutSeconds);
  plhs[0] = mxOut1;
  */

}

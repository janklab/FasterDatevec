#include "mex.hpp"
#include "mexAdapter.hpp"
#include <math.h>

using namespace matlab::data;

class MexFunction : public matlab::mex::Function {

    ArrayFactory factory;

public:

    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {

        std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();

        // Inputs
        TypedArray<double> inDatenums = std::move(inputs[0]);
        CellArray constantsInCell = std::move(inputs[1]);
        TypedArrayRef<double> mxFirstPrecalcYear = constantsInCell[0];
        double firstPrecalcYear = mxFirstPrecalcYear[0];
        TypedArrayRef<double> mxFirstPrecalcDatenum = constantsInCell[2];
        int32_t firstPrecalcDaypart = (int32_t) mxFirstPrecalcDatenum[0];
        TypedArrayRef<int32_t> mxDatenumDays = constantsInCell[5];
        TypedArrayRef<uint16_t> mxPrecalcedDateparts = constantsInCell[10];
        size_t n = inDatenums.getNumberOfElements();

        // Outputs
        TypedArray<int16_t> year = factory.createArray<int16_t>({n, 1});
        TypedArray<uint8_t> month = factory.createArray<uint8_t>({n, 1});
        TypedArray<uint8_t> day = factory.createArray<uint8_t>({n, 1});
        TypedArray<uint8_t> hour = factory.createArray<uint8_t>({n, 1});
        TypedArray<uint8_t> minute = factory.createArray<uint8_t>({n, 1});
        TypedArray<double> second = factory.createArray<double>({n, 1});

        int16_t tmpYear;
        uint8_t tmpMonth;
        uint8_t tmpDay;
        uint8_t tmpHour;
        uint8_t tmpMinute;
        double tmpSecond;

        for (size_t i = 0; i < n; i++) {
            double dnum = inDatenums[i];
            double dayPartDouble = floor(dnum);
            double timePart = dnum - dayPartDouble;
            int32_t dayPart = (int32_t) dayPartDouble;
            
            size_t ixPrecalc = dayPart - firstPrecalcDaypart;
            tmpYear = mxPrecalcedDateparts[ixPrecalc][0];
            tmpMonth = mxPrecalcedDateparts[ixPrecalc][1];
            tmpDay = mxPrecalcedDateparts[ixPrecalc][2];
            year[i] = tmpYear;
            month[i] = tmpMonth;
            day[i] = tmpDay;
            
            calcTimeParts(timePart, &tmpHour, &tmpMinute, &tmpSecond);
            hour[i] = tmpHour;
            minute[i] = tmpMinute;
            second[i] = tmpSecond;
        }

        CellArray partsOut = factory.createCellArray({1,6},
            year, month, day, hour, minute, second);
        outputs[0] = std::move(partsOut);
    }

    void calcTimeParts(double timePart, uint8_t *hour, uint8_t *minute, double *seconds) {
        double secondsOfDayWithFrac = timePart * (24 * 60 * 60);
        double secondsOfDayDouble = floor(secondsOfDayWithFrac);
        double fractionalSeconds = secondsOfDayWithFrac - secondsOfDayDouble;
        uint32_t secondsOfDay = (uint32_t) secondsOfDayDouble;
        uint8_t hourOfDay = secondsOfDay / (60 * 60);
        uint32_t secondsOfHour = secondsOfDay - (hourOfDay * 60 * 60);
        uint8_t minuteOfHour = secondsOfHour / 60;
        uint32_t secondsOfMinute = secondsOfHour - (minuteOfHour * 60);
        double secondsWithFrac = ((double) secondsOfMinute) + fractionalSeconds;

        *hour = hourOfDay;
        *minute = minuteOfHour;
        *seconds = secondsWithFrac;
    }

};
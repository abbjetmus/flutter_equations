import 'dart:math';
import 'package:collection/collection.dart';

class AnalysisService {
  rmssdAnalysis(List RRValues, double interval) {
    List RRValuesInterval = [];
    num RRValuesTime = 0;
    int i = RRValues.length - 1;

    while (RRValuesTime < interval) {
      RRValuesInterval.add(RRValues[i]["RR_Value"]);
      RRValuesTime += RRValues[i]["RR_Value"];
      i -= 1;
    }
    return rmssdCalc(List.from(RRValuesInterval.reversed));
  }

  num rmssdCalc(List RRValues) {
    int i = 0;
    num RRSum = 0;
    while (i < RRValues.length - 1) {
      RRSum += pow((RRValues[(i + 1)] - RRValues[i]), 2);
      i += 1;
    }
    num rmssd = sqrt(1 / (RRValues.length - 1) * RRSum);
    return rmssd;
  }

  num hrCalc(List RRValues) {
    num RRSum = 0;
    int i = 0;
    for (i; i < RRValues.length; i += 1) {
      RRSum += RRValues[i];
    }
    num averageRR = RRSum / RRValues.length;
    int hr = 60000 ~/ averageRR;
    return hr;
  }

  hrAnalysis(List RRValues) {
    num RRSum = 0;
    int i = 0;
    for (i; i < RRValues.length; i += 1) {
      RRSum += RRValues[i]["RR_Value"];
    }
    num averageRR = RRSum / RRValues.length;
    int hr = 60000 ~/ averageRR;
    print(hr);
    return hr;
  }
}

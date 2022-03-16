import 'dart:math';
import 'package:collection/collection.dart';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';

enum TypeOfExertion { MentalStress, PhysicalStress, Recovery }

class PerceivedExertion {
  DateTime date;
  TypeOfExertion typeOfExertion;
  double ratingOfPerceivedExertion;
  String message;

  PerceivedExertion(
      {required this.date,
      required this.typeOfExertion,
      required this.ratingOfPerceivedExertion,
      required this.message});
}

bool hasMovedCalc(List<int> movements) {
  if (movements.isNotEmpty) {
    var sum = movements.sum;
    var ratio = sum / movements.length;
    return ratio.round() == 0 ? false : true;
  }
  return false;
}

int checklIfIsMoving(ActivityEvent activityEvent) {
  var isMoving = (activityEvent.type == ActivityType.ON_BICYCLE ||
      activityEvent.type == ActivityType.ON_FOOT ||
      activityEvent.type == ActivityType.RUNNING ||
      activityEvent.type == ActivityType.WALKING);
  // && activityEvent.confidence > 50;

  return isMoving ? 1 : 0;
}

PerceivedExertion? checkForCondition(
    num Ri, num Pi, bool Ai, int Rsa, int Psa) {
  PerceivedExertion? result;

  result = mentalStress(Ri, Pi, Ai, Rsa, Psa);

  if (result != null) return result;

  result = physicalStress(Pi, Ai, Psa);

  if (result != null) return result;

  result = recovery(Ri, Pi, Rsa, Psa);

  return result;
}

PerceivedExertion? mentalStress(num Ri, num Pi, bool Ai, num Rsa, num Psa) {
  final RiLimit = Rsa * 0.8;
  final PiLimit = Psa * 1.2;

  if (Ri < RiLimit && Pi > PiLimit && !Ai) {
    PerceivedExertion? result = PerceivedExertion(
        date: DateTime.now(),
        typeOfExertion: TypeOfExertion.MentalStress,
        ratingOfPerceivedExertion: -1,
        message: '');

    double RiLimitLower = 0;
    double RiIncrement = 3;
    double PiIncrement = 3;

    if (RiLimit >= 30) {
      RiLimitLower = RiLimit - 30;
    } else {
      RiIncrement = RiLimit / 10;
    }

    double RiRating = 0;
    double PiRating = 0;

    if (Ri < RiLimitLower + RiIncrement) {
      RiRating = 10;
    } else if (Ri < RiLimitLower + RiIncrement * 2) {
      RiRating = 9;
    } else if (Ri < RiLimitLower + RiIncrement * 3) {
      RiRating = 8;
    } else if (Ri < RiLimitLower + RiIncrement * 4) {
      RiRating = 7;
    } else if (Ri < RiLimitLower + RiIncrement * 5) {
      RiRating = 6;
    } else if (Ri < RiLimitLower + RiIncrement * 6) {
      RiRating = 5;
    } else if (Ri < RiLimitLower + RiIncrement * 7) {
      RiRating = 4;
    } else if (Ri < RiLimitLower + RiIncrement * 8) {
      RiRating = 3;
    } else if (Ri < RiLimitLower + RiIncrement * 9) {
      RiRating = 2;
    } else {
      RiRating = 1;
    }

    if (Pi < PiLimit + PiIncrement) {
      PiRating = 1;
    } else if (Pi < PiLimit + PiIncrement * 2) {
      PiRating = 2;
    } else if (Pi < PiLimit + PiIncrement * 3) {
      PiRating = 3;
    } else if (Pi < PiLimit + PiIncrement * 4) {
      PiRating = 4;
    } else if (Pi < PiLimit + PiIncrement * 5) {
      PiRating = 5;
    } else if (Pi < PiLimit + PiIncrement * 6) {
      PiRating = 6;
    } else if (Pi < PiLimit + PiIncrement * 7) {
      PiRating = 7;
    } else if (Pi < PiLimit + PiIncrement * 8) {
      PiRating = 8;
    } else if (Pi < PiLimit + PiIncrement * 9) {
      PiRating = 9;
    } else {
      PiRating = 10;
    }

    result.ratingOfPerceivedExertion = PiRating * RiRating / 10;
    return result;
  }
  return null;
}

PerceivedExertion? physicalStress(num Pi, bool Ai, num Psa) {
  var PiLimit = Psa * 1.7;

  if (Pi > PiLimit && Ai) {
    PerceivedExertion? result = PerceivedExertion(
        date: DateTime.now(),
        typeOfExertion: TypeOfExertion.PhysicalStress,
        ratingOfPerceivedExertion: -1,
        message: '');

    double PiRating = 0;
    const PiIncrement = 3;
    if (Pi < PiLimit + PiIncrement) {
      PiRating = 1;
    } else if (Pi < PiLimit + PiIncrement * 2) {
      PiRating = 2;
    } else if (Pi < PiLimit + PiIncrement * 3) {
      PiRating = 3;
    } else if (Pi < PiLimit + PiIncrement * 4) {
      PiRating = 4;
    } else if (Pi < PiLimit + PiIncrement * 5) {
      PiRating = 5;
    } else if (Pi < PiLimit + PiIncrement * 6) {
      PiRating = 6;
    } else if (Pi < PiLimit + PiIncrement * 7) {
      PiRating = 7;
    } else if (Pi < PiLimit + PiIncrement * 8) {
      PiRating = 8;
    } else if (Pi < PiLimit + PiIncrement * 9) {
      PiRating = 9;
    } else {
      PiRating = 10;
    }
    result.ratingOfPerceivedExertion = PiRating;
    return result;
  }
  return null;
}

PerceivedExertion? recovery(num Ri, num Pi, num Rsa, num Psa) {
  var RiLimit = Rsa * 1.2;
  var PiLimit = Psa * 0.9;

  if (Ri > RiLimit && Pi < PiLimit) {
    PerceivedExertion? result = PerceivedExertion(
        date: DateTime.now(),
        typeOfExertion: TypeOfExertion.Recovery,
        ratingOfPerceivedExertion: -1,
        message: '');

    double PiLimitLower = 0;
    double RiIncrement = 3;
    double PiIncrement = 3;

    if (PiLimit >= 30) {
      PiLimitLower = PiLimit - 30;
    } else {
      PiIncrement = PiLimit / 10;
    }

    double RiRating = 0;
    double PiRating = 0;

    if (Ri < RiLimit + RiIncrement) {
      RiRating = 1;
    } else if (Ri < RiLimit + RiIncrement * 2) {
      RiRating = 2;
    } else if (Ri < RiLimit + RiIncrement * 3) {
      RiRating = 3;
    } else if (Ri < RiLimit + RiIncrement * 4) {
      RiRating = 4;
    } else if (Ri < RiLimit + RiIncrement * 5) {
      RiRating = 5;
    } else if (Ri < RiLimit + RiIncrement * 6) {
      RiRating = 6;
    } else if (Ri < RiLimit + RiIncrement * 7) {
      RiRating = 7;
    } else if (Ri < RiLimit + RiIncrement * 8) {
      RiRating = 8;
    } else if (Ri < RiLimit + RiIncrement * 9) {
      RiRating = 9;
    } else {
      RiRating = 10;
    }

    if (Pi < PiLimitLower + PiIncrement) {
      PiRating = 10;
    } else if (Pi < PiLimitLower + PiIncrement * 2) {
      PiRating = 9;
    } else if (Pi < PiLimitLower + PiIncrement * 3) {
      PiRating = 8;
    } else if (Pi < PiLimitLower + PiIncrement * 4) {
      PiRating = 7;
    } else if (Pi < PiLimitLower + PiIncrement * 5) {
      PiRating = 6;
    } else if (Pi < PiLimitLower + PiIncrement * 6) {
      PiRating = 5;
    } else if (Pi < PiLimitLower + PiIncrement * 7) {
      PiRating = 4;
    } else if (Pi < PiLimitLower + PiIncrement * 8) {
      PiRating = 3;
    } else if (Pi < PiLimitLower + PiIncrement * 9) {
      PiRating = 2;
    } else {
      PiRating = 1;
    }

    result.ratingOfPerceivedExertion = PiRating * RiRating / 10;
    return result;
  }
  return null;
}

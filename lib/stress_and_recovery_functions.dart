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
    Random random = Random();
    var rating = random.nextInt(8);
    PerceivedExertion? result = PerceivedExertion(
        date: DateTime.now(),
        typeOfExertion: TypeOfExertion.MentalStress,
        ratingOfPerceivedExertion: -1,
        message: '');

    var RiLimitLower = RiLimit - 30;
    var PiLimitUpper = PiLimit + 30;

    double RiRating = 0;
    double PiRating = 0;

    if (Ri < RiLimitLower + 3) {
      RiRating = 10;
    } else if (Ri < RiLimitLower + 6) {
      RiRating = 9;
    } else if (Ri < RiLimitLower + 9) {
      RiRating = 8;
    } else if (Ri < RiLimitLower + 12) {
      RiRating = 7;
    } else if (Ri < RiLimitLower + 15) {
      RiRating = 6;
    } else if (Ri < RiLimitLower + 18) {
      RiRating = 5;
    } else if (Ri < RiLimitLower + 21) {
      RiRating = 4;
    } else if (Ri < RiLimitLower + 24) {
      RiRating = 3;
    } else if (Ri < RiLimitLower + 27) {
      RiRating = 2;
    } else if (Ri < RiLimitLower + 30) {
      RiRating = 1;
    }

    if (Pi < PiLimit + 3) {
      PiRating = 1;
    } else if (Pi < PiLimit + 6) {
      PiRating = 2;
    } else if (Pi < PiLimit + 9) {
      PiRating = 3;
    } else if (Pi < PiLimit + 12) {
      PiRating = 4;
    } else if (Pi < PiLimit + 15) {
      PiRating = 5;
    } else if (Pi < PiLimit + 18) {
      PiRating = 6;
    } else if (Pi < PiLimit + 21) {
      PiRating = 7;
    } else if (Pi < PiLimit + 24) {
      PiRating = 8;
    } else if (Pi < PiLimit + 27) {
      PiRating = 9;
    } else if (Pi < PiLimit + 30) {
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
    Random random = Random();
    var rating = random.nextInt(8);
    PerceivedExertion? result = PerceivedExertion(
        date: DateTime.now(),
        typeOfExertion: TypeOfExertion.MentalStress,
        ratingOfPerceivedExertion: -1,
        message: '');

    var PiLimitUpper = PiLimit + 30;

    double PiScalar = 0;

    if (Pi < PiLimit + 3) {
      PiScalar = 1;
    } else if (Pi < PiLimit + 6) {
      PiScalar = 2;
    } else if (Pi < PiLimit + 9) {
      PiScalar = 3;
    } else if (Pi < PiLimit + 12) {
      PiScalar = 4;
    } else if (Pi < PiLimit + 15) {
      PiScalar = 5;
    } else if (Pi < PiLimit + 18) {
      PiScalar = 6;
    } else if (Pi < PiLimit + 21) {
      PiScalar = 7;
    } else if (Pi < PiLimit + 24) {
      PiScalar = 8;
    } else if (Pi < PiLimit + 27) {
      PiScalar = 9;
    } else if (Pi < PiLimit + 30) {
      PiScalar = 10;
    }
    result.ratingOfPerceivedExertion = PiScalar;
    return result;
  }
  return null;
}

PerceivedExertion? recovery(num Ri, num Pi, num Rsa, num Psa) {
  var RiLimit = Rsa * 1.2;
  var PiLimit = Psa * 0.9;

  if (Ri > RiLimit && Pi < PiLimit) {
    Random random = Random();
    var rating = random.nextInt(8);
    PerceivedExertion? result = PerceivedExertion(
        date: DateTime.now(),
        typeOfExertion: TypeOfExertion.MentalStress,
        ratingOfPerceivedExertion: -1,
        message: '');

    var RiLimitLower = RiLimit - 30;
    var PiLimitUpper = PiLimit + 30;

    double RiScalar = 0;
    double PiScalar = 0;

    if (Ri < RiLimitLower + 3) {
      RiScalar = 10;
    } else if (Ri < RiLimitLower + 6) {
      RiScalar = 9;
    } else if (Ri < RiLimitLower + 9) {
      RiScalar = 8;
    } else if (Ri < RiLimitLower + 12) {
      RiScalar = 7;
    } else if (Ri < RiLimitLower + 15) {
      RiScalar = 6;
    } else if (Ri < RiLimitLower + 18) {
      RiScalar = 5;
    } else if (Ri < RiLimitLower + 21) {
      RiScalar = 4;
    } else if (Ri < RiLimitLower + 24) {
      RiScalar = 3;
    } else if (Ri < RiLimitLower + 27) {
      RiScalar = 2;
    } else if (Ri < RiLimitLower + 30) {
      RiScalar = 1;
    }

    if (Pi < PiLimit + 3) {
      PiScalar = 1;
    } else if (Pi < PiLimit + 6) {
      PiScalar = 2;
    } else if (Pi < PiLimit + 9) {
      PiScalar = 3;
    } else if (Pi < PiLimit + 12) {
      PiScalar = 4;
    } else if (Pi < PiLimit + 15) {
      PiScalar = 5;
    } else if (Pi < PiLimit + 18) {
      PiScalar = 6;
    } else if (Pi < PiLimit + 21) {
      PiScalar = 7;
    } else if (Pi < PiLimit + 24) {
      PiScalar = 8;
    } else if (Pi < PiLimit + 27) {
      PiScalar = 9;
    } else if (Pi < PiLimit + 30) {
      PiScalar = 10;
    }

    result.ratingOfPerceivedExertion = PiScalar * RiScalar / 10;
    return result;
  }
  return null;
}

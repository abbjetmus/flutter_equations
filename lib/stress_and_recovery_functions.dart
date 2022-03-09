import 'dart:math';
import 'package:collection/collection.dart';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';

enum RatingOfPerceivedExertion {
  NoExertionAtAll,
  ExtremelyLight,
  VeryLight,
  Light,
  SomewhatHard,
  Hard,
  VeryHard,
  ExtremelyHard,
  MaximalExcertion
}

enum TypeOfExertion { MentalStress, PhysicalStress, Recovery }

class PerceivedExertion {
  DateTime date;
  TypeOfExertion typeOfExertion;
  RatingOfPerceivedExertion ratingOfPerceivedExertion;
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
  // && activityEvent.confidence > 40;

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
  if (Ri < Rsa * 0.8 && Pi > Psa * 1.2 && !Ai) {
    Random random = Random();
    var rating = random.nextInt(8);
    PerceivedExertion? result = PerceivedExertion(
        date: DateTime.now(),
        typeOfExertion: TypeOfExertion.MentalStress,
        ratingOfPerceivedExertion: RatingOfPerceivedExertion.values[rating],
        message: '');

    switch (result.ratingOfPerceivedExertion) {
      case RatingOfPerceivedExertion.NoExertionAtAll:
        result.message = "Du har ingen mental stress";
        break;
      case RatingOfPerceivedExertion.ExtremelyLight:
        result.message = "Du har extremt lätt mental stress";
        break;
      case RatingOfPerceivedExertion.VeryLight:
        result.message = "Du har väldigt lätt mental stress";
        break;
      case RatingOfPerceivedExertion.Light:
        result.message = "Du har lätt mental stress";
        break;
      case RatingOfPerceivedExertion.SomewhatHard:
        result.message = "Du har någorlunda mental stress";
        break;
      case RatingOfPerceivedExertion.Hard:
        result.message = "Du har hård mental stress";
        break;
      case RatingOfPerceivedExertion.VeryHard:
        result.message = "Du har mycket hård mental stress";
        break;
      case RatingOfPerceivedExertion.ExtremelyHard:
        result.message = "Du har extremet hård mental stress";
        break;
      case RatingOfPerceivedExertion.MaximalExcertion:
        result.message = "Du har maximal mental stress";
        break;
      default:
    }
    return result;
  }
  return null;
}

PerceivedExertion? physicalStress(num Pi, bool Ai, num Psa) {
  if (Pi > Psa * 1.7 && Ai) {
    Random random = Random();
    var rating = random.nextInt(8);
    PerceivedExertion? result = PerceivedExertion(
        date: DateTime.now(),
        typeOfExertion: TypeOfExertion.MentalStress,
        ratingOfPerceivedExertion: RatingOfPerceivedExertion.values[rating],
        message: '');

    switch (result.ratingOfPerceivedExertion) {
      case RatingOfPerceivedExertion.NoExertionAtAll:
        result.message = "Du har ingen fysisk stress";
        break;
      case RatingOfPerceivedExertion.ExtremelyLight:
        result.message = "Du har extremt lätt fysisk stress";
        break;
      case RatingOfPerceivedExertion.VeryLight:
        result.message = "Du har väldigt lätt fysisk stress";
        break;
      case RatingOfPerceivedExertion.Light:
        result.message = "Du har lätt fysisk stress";
        break;
      case RatingOfPerceivedExertion.SomewhatHard:
        result.message = "Du har någorlunda fysisk stress";
        break;
      case RatingOfPerceivedExertion.Hard:
        result.message = "Du har hård fysisk stress";
        break;
      case RatingOfPerceivedExertion.VeryHard:
        result.message = "Du har mycket hård fysisk stress";
        break;
      case RatingOfPerceivedExertion.ExtremelyHard:
        result.message = "Du har extremet hård fysisk stress";
        break;
      case RatingOfPerceivedExertion.MaximalExcertion:
        result.message = "Du har maximal fysisk stress";
        break;
      default:
    }
    return result;
  }
  return null;
}

PerceivedExertion? recovery(num Ri, num Pi, num Rsa, num Psa) {
  if (Ri < Rsa * 1.2 && Pi < Psa * 0.9) {
    Random random = Random();
    var rating = random.nextInt(8);
    PerceivedExertion? result = PerceivedExertion(
        date: DateTime.now(),
        typeOfExertion: TypeOfExertion.MentalStress,
        ratingOfPerceivedExertion: RatingOfPerceivedExertion.values[rating],
        message: '');

    switch (result.ratingOfPerceivedExertion) {
      case RatingOfPerceivedExertion.NoExertionAtAll:
        result.message = "Du har ingen återhämtning";
        break;
      case RatingOfPerceivedExertion.ExtremelyLight:
        result.message = "Du har extremt lätt återhämtning";
        break;
      case RatingOfPerceivedExertion.VeryLight:
        result.message = "Du har väldigt lätt återhämtning";
        break;
      case RatingOfPerceivedExertion.Light:
        result.message = "Du har lätt återhämtning";
        break;
      case RatingOfPerceivedExertion.SomewhatHard:
        result.message = "Du har någorlunda återhämtning";
        break;
      case RatingOfPerceivedExertion.Hard:
        result.message = "Du har hård återhämtning";
        break;
      case RatingOfPerceivedExertion.VeryHard:
        result.message = "Du har mycket hård återhämtning";
        break;
      case RatingOfPerceivedExertion.ExtremelyHard:
        result.message = "Du har extremet hård återhämtning";
        break;
      case RatingOfPerceivedExertion.MaximalExcertion:
        result.message = "Du har maximal återhämtning stress";
        break;
      default:
    }
    return result;
  }
  return null;
}

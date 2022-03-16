// Import the test package and Counter class
import 'package:flutter_equations/stress_and_recovery_functions.dart';
import 'package:test/test.dart';

void main() {
  test('Mental Stress null', () {
    PerceivedExertion? result = mentalStress(35, 65, false, 40, 80);
    expect(result?.ratingOfPerceivedExertion, null);
  });

  test('Mental Stress 8', () {
    PerceivedExertion? result = mentalStress(10, 100, false, 40, 60);
    expect(result?.ratingOfPerceivedExertion, 8.0);
  });
}

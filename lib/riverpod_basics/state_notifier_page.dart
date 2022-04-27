import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Car {
  final int speed;
  final int doors;

  const Car({this.speed = 120, this.doors = 4});

  Car copy({int? speed, int? doors}) =>
      Car(speed: speed ?? this.speed, doors: doors ?? this.doors);
}

class CarNotifier extends StateNotifier<Car> {
  CarNotifier() : super(const Car());

  void setDoors(int doors) {
    final newState = state.copy(doors: doors);
  }
}

// final carProvider = ChangeNotifierProvider<CarNotifier>((ref) => CarNotifier());

class ChangeNotifierPage extends ConsumerWidget {
  const ChangeNotifierPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final car = ref.watch(carProvider);
    return const Scaffold();
  }
}

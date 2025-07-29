import 'dart:async';
import 'package:pedometer/pedometer.dart';

class PedometerService {
  Stream<int> get stepStream {
    return Pedometer.stepCountStream.map((stepCount) => stepCount.steps);
  }

  Stream<String> get pedestrianStatusStream {
    return Pedometer.pedestrianStatusStream.map((status) => status.status);
  }

  Future<bool> isStepCountingAvailable() async {
    try {
      final stepCountStream = Pedometer.stepCountStream;
      await stepCountStream.first.timeout(const Duration(seconds: 5));
      return true;
    } catch (e) {
      return false;
    }
  }
}

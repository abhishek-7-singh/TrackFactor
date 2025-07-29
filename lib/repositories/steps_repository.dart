import 'package:hive/hive.dart';
import '../models/step_data.dart';
import '../services/pedometer_service.dart';

class StepsRepository {
  final PedometerService pedometerService;
  static const String _stepsBoxName = 'step_data';

  StepsRepository(this.pedometerService);

  Future<Box<StepData>> get _stepsBox async {
    if (!Hive.isBoxOpen(_stepsBoxName)) {
      return await Hive.openBox<StepData>(_stepsBoxName);
    }
    return Hive.box<StepData>(_stepsBoxName);
  }

  Stream<int> get stepStream => pedometerService.stepStream;

  Future<List<StepData>> getStepHistory() async {
    final box = await _stepsBox;
    final data = box.values.toList();
    data.sort((a, b) => b.date.compareTo(a.date));
    return data;
  }

  Future<void> saveStepData(StepData stepData) async {
    final box = await _stepsBox;
    final key = '${stepData.date.year}-${stepData.date.month}-${stepData.date.day}';
    await box.put(key, stepData);
  }

  Future<StepData?> getTodaysSteps() async {
    final box = await _stepsBox;
    final today = DateTime.now();
    final key = '${today.year}-${today.month}-${today.day}';
    return box.get(key);
  }
}
